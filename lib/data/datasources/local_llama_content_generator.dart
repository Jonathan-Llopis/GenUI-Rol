import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import 'package:llamadart/llamadart.dart';
import 'package:rol_genui/core/logging/app_logger.dart';

class LocalLlamaContentGenerator implements ContentGenerator {
  LocalLlamaContentGenerator({
    required this.engine,
    this.systemInstruction,
  });

  final LlamaEngine engine;
  final String? systemInstruction;
  final _log = getLogger('LocalLlamaContentGenerator');

  final _a2uiController = StreamController<A2uiMessage>.broadcast();
  final _textController = StreamController<String>.broadcast();
  final _errorController = StreamController<ContentGeneratorError>.broadcast();
  final _isProcessing = ValueNotifier<bool>(false);

  @override
  Stream<A2uiMessage> get a2uiMessageStream => _a2uiController.stream;

  @override
  Stream<String> get textResponseStream => _textController.stream;

  @override
  Stream<ContentGeneratorError> get errorStream => _errorController.stream;

  @override
  ValueListenable<bool> get isProcessing => _isProcessing;

  @override
  Future<void> sendRequest(
    ChatMessage message, {
    Iterable<ChatMessage>? history,
  }) async {
    if (_isProcessing.value) return;
    _isProcessing.value = true;

    try {
      String prompt = '';
      if (systemInstruction != null) {
        prompt += 'System: $systemInstruction\n';
      }
      if (history != null) {
        for (final m in history) {
          final role = m is UserMessage ? "User" : "Assistant";
          String msgText = "";
          if (m is UserMessage) msgText = m.text;
          if (m is AiTextMessage) msgText = m.text;
          prompt += '$role: $msgText\n';
        }
      }
      
      String currentText = "";
      if (message is UserMessage) currentText = message.text;
      prompt += 'User: $currentText\nAssistant: ';

      String fullResponse = '';
      await for (final token in engine.generate(prompt)) {
        if (_isProcessing.value == false) break;
        fullResponse += token;
        _textController.add(token);
      }

      _log.fine('GenUI Local Response: $fullResponse');
      _parseA2uiResponse(fullResponse);

    } catch (e, st) {
      _log.severe('Error en LocalLlamaContentGenerator', e, st);
      _errorController.add(ContentGeneratorError(e, st));
    } finally {
      _isProcessing.value = false;
    }
  }

  void _parseA2uiResponse(String text) {
    try {
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start != -1 && end != -1 && end > start) {
        final jsonStr = text.substring(start, end + 1);
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        _a2uiController.add(A2uiMessage.fromJson(json));
      }
    } catch (e) {
      _log.warning('No se pudo parsear GenUI del texto local');
    }
  }

  @override
  void dispose() {
    _a2uiController.close();
    _textController.close();
    _errorController.close();
    _isProcessing.dispose();
  }
}
