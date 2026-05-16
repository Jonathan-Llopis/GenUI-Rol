import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:rol_genui/core/logging/app_logger.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/core/prompts/game_prompt_builder.dart';
import 'package:rol_genui/domain/entities/combat.dart';
import 'package:rol_genui/domain/entities/inventory.dart';

final _chatLog = getLogger('ChatRemoteDataSource');
final _gameLog = getLogger('GameRemoteDataSource');

abstract class ChatRemoteDataSource {
  Future<String> startChatGemini(String prompt);
  Future<String> sendMessageGemini(String message, List<ByteData>? imageBytes);
  Future<String> startChatAssistant(String prompt);
  Future<String> sendMessageAssitant(
    String message,
    List<ByteData>? imageBytes,
  );
}

abstract class GameRemoteDataSource {
  Future<StoryTurnResponse> startGameSession({
    required Character character,
    required RuleSystem system,
    required String languageCode,
  });

  Future<StoryTurnResponse> sendGameChoice({
    required String choice,
    required String languageCode,
  });

  Future<Uint8List?> generateSceneImage(String imagePrompt);

  void resetSession();
}

class StoryTurnResponse {
  const StoryTurnResponse({
    required this.story,
    required this.choices,
    required this.imagePrompt,
    this.characterUpdates = const {},
    this.inventoryUpdates = const [],
    this.combat,
    this.sessionTitle,
  });

  final String story;
  final List<String> choices;
  final String imagePrompt;
  final Map<String, int> characterUpdates;
  final List<InventoryUpdate> inventoryUpdates;
  final CombatState? combat;
  final String? sessionTitle;

  factory StoryTurnResponse.fromJson(Map<String, dynamic> json) {
    return StoryTurnResponse(
      story: json['story'] as String? ?? '',
      choices:
          (json['choices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imagePrompt: json['image_prompt'] as String? ?? '',
      characterUpdates:
          (json['character_updates'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toInt()),
          ) ??
          {},
      inventoryUpdates:
          (json['inventory_updates'] as List<dynamic>?)
              ?.map((e) => InventoryUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      combat: json['combat'] != null
          ? CombatState.fromJson(json['combat'] as Map<String, dynamic>)
          : null,
      sessionTitle: json['session_title'] as String?,
    );
  }
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key no encontrada en las variables de entorno.');
    }
    model = GenerativeModel(
      // gemini-2.5-flash: estable, gratis con Gemini Developer API
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
  }

  late final GenerativeModel model;
  late dynamic chat;

  @override
  Future<String> startChatGemini(String prompt) async {
    _chatLog.info('Iniciando chat Gemini');
    _chatLog.fine(
      'Prompt: ${prompt.substring(0, prompt.length.clamp(0, 100))}...',
    );
    try {
      chat = model.startChat();
      final response = await chat.sendMessage(Content.text(prompt));
      if (response.text != '') {
        _chatLog.info('Chat iniciado correctamente');
        return response.text.toString();
      }
      throw Exception('Respuesta vacía');
    } catch (e, st) {
      _chatLog.severe('Error al iniciar chat Gemini', e, st);
      throw Exception('Error al iniciar el Chat.');
    }
  }

  @override
  Future<String> sendMessageGemini(
    String message,
    List<ByteData>? imageBytes,
  ) async {
    _chatLog.fine(
      'Enviando mensaje Gemini (imágenes: ${imageBytes?.length ?? 0})',
    );
    try {
      List<Content> content = [Content.text(message)];
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final dataParts = imageBytes
            .map((b) => DataPart('image/jpeg', b.buffer.asUint8List()))
            .toList();
        content = [
          Content.multi([TextPart(message), ...dataParts]),
        ];
      }
      final response = await chat.sendMessage(content.first);
      if (response.text.isNotEmpty) return response.text.toString();
      throw Exception('Respuesta vacía');
    } catch (e, st) {
      _chatLog.severe('Error al enviar mensaje Gemini', e, st);
      throw Exception('Error al enviar el mensaje.');
    }
  }

  @override
  Future<String> startChatAssistant(String prompt) async {
    _chatLog.info('Iniciando chat Assistant');
    try {
      chat = model.startChat();
      final response = await chat.sendMessage(Content.text(prompt));
      if (response.text != '') return response.text.toString();
      throw Exception('Respuesta vacía');
    } catch (e, st) {
      _chatLog.severe('Error al iniciar chat Assistant', e, st);
      throw Exception('Error al iniciar el Chat.');
    }
  }

  @override
  Future<String> sendMessageAssitant(
    String message,
    List<ByteData>? imageBytes,
  ) async {
    _chatLog.fine('Enviando mensaje Assistant');
    try {
      List<Content> content = [Content.text(message)];
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final dataParts = imageBytes
            .map((b) => DataPart('image/jpeg', b.buffer.asUint8List()))
            .toList();
        content = [
          Content.multi([TextPart(message), ...dataParts]),
        ];
      }
      final response = await chat.sendMessage(content.first);
      if (response.text.isNotEmpty) return response.text.toString();
      throw Exception('Respuesta vacía');
    } catch (e, st) {
      _chatLog.severe('Error al enviar mensaje Assistant', e, st);
      throw Exception('Error al enviar el mensaje.');
    }
  }
}

class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  GameRemoteDataSourceImpl() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key no encontrada en las variables de entorno.');
    }
  }

  ChatSession? _gameChat;

  @override
  Future<StoryTurnResponse> startGameSession({
    required Character character,
    required RuleSystem system,
    required String languageCode,
  }) async {
    _gameLog.info(
      'Iniciando sesión de juego: personaje="${character.name}" sistema=${system.id.name} idioma=$languageCode',
    );
    try {
      final systemPrompt = buildSystemPrompt(
        character: character,
        system: system,
        languageCode: languageCode,
      );
      final startPrompt = buildStartGamePrompt(
        system: system,
        languageCode: languageCode,
      );

      final apiKey = dotenv.env['OPENAI_API_KEY']!;
      final modelWithSystem = GenerativeModel(
        model: 'gemini-3-flash-preview',
        apiKey: apiKey,
        systemInstruction: Content.system(systemPrompt),
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          temperature: 0.9,
          maxOutputTokens: 2048,
        ),
      );

      _gameChat = modelWithSystem.startChat();
      _gameLog.fine('Chat de juego iniciado, enviando prompt de inicio...');

      final response = await _gameChat!.sendMessage(Content.text(startPrompt));
      final result = _parseStoryResponse(response.text ?? '{}');
      _gameLog.info(
        'Sesión iniciada correctamente. Opciones: ${result.choices.length}',
      );
      return result;
    } catch (e, st) {
      _gameLog.severe('Error al iniciar sesión de juego', e, st);
      rethrow;
    }
  }

  @override
  Future<StoryTurnResponse> sendGameChoice({
    required String choice,
    required String languageCode,
  }) async {
    _gameLog.info('Procesando elección del jugador: "$choice"');
    if (_gameChat == null) {
      _gameLog.severe('sendGameChoice llamado sin sesión activa');
      throw Exception('No hay sesión de juego activa.');
    }
    try {
      final prompt = buildChoicePrompt(
        choice: choice,
        languageCode: languageCode,
      );
      final response = await _gameChat!.sendMessage(Content.text(prompt));
      final result = _parseStoryResponse(response.text ?? '{}');
      _gameLog.info(
        'Elección procesada. Nuevas opciones: ${result.choices.length}',
      );
      if (result.characterUpdates.isNotEmpty) {
        _gameLog.fine(
          'Actualizaciones de estadísticas: ${result.characterUpdates}',
        );
      }
      return result;
    } catch (e, st) {
      _gameLog.severe('Error al procesar elección "$choice"', e, st);
      rethrow;
    }
  }

  @override
  Future<Uint8List?> generateSceneImage(String imagePrompt) async {
    _gameLog.fine(
      'Generando imagen de escena: "${imagePrompt.substring(0, imagePrompt.length.clamp(0, 80))}"',
    );
    // Intenta primero con Gemini (requiere Blaze; si el usuario lo activa, funciona)
    final geminiResult = await _generateWithGemini(imagePrompt);
    if (geminiResult != null) return geminiResult;
    // Fallback: picsum.photos — imágenes bonitas consistentes por escena
    return _generateWithPicsum(imagePrompt);
  }

  Future<Uint8List?> _generateWithGemini(String imagePrompt) async {
    try {
      final apiKey = dotenv.env['OPENAI_API_KEY']!;
      final prompt =
          'RPG scene illustration, digital art, cinematic, no text, no captions: $imagePrompt';
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-pro-image-preview:generateContent?key=$apiKey',
      );
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'responseModalities': ['IMAGE', 'TEXT'],
        },
      });
      final response = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 45));

      if (response.statusCode != 200) {
        _gameLog.fine(
          'Gemini image no disponible (status ${response.statusCode}), usando fallback',
        );
        return null;
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final parts =
          ((json['candidates'] as List?)?.first?['content']?['parts']
              as List?) ??
          [];
      for (final part in parts) {
        final inlineData = part['inlineData'] as Map<String, dynamic>?;
        if (inlineData != null &&
            (inlineData['mimeType'] as String? ?? '').startsWith('image/')) {
          final bytes = base64Decode(inlineData['data'] as String);
          _gameLog.info('Imagen Gemini generada (${bytes.length} bytes)');
          return bytes;
        }
      }
      return null;
    } catch (e) {
      _gameLog.fine('Gemini image error: $e');
      return null;
    }
  }

  Future<Uint8List?> _generateWithPicsum(String imagePrompt) async {
    try {
      // Seed determinista: cada escena siempre tiene la misma imagen
      final seed =
          imagePrompt.codeUnits.fold(0, (a, b) => (a * 31 + b) & 0x7FFFFFFF) %
          1000;
      final uri = Uri.parse('https://picsum.photos/seed/$seed/512/256');
      _gameLog.fine('Picsum fallback seed=$seed');
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        _gameLog.info(
          'Imagen Picsum cargada (${response.bodyBytes.length} bytes, seed=$seed)',
        );
        return response.bodyBytes;
      }
      _gameLog.warning('Picsum respondió con status ${response.statusCode}');
      return null;
    } catch (e, st) {
      _gameLog.warning('No se pudo obtener imagen Picsum', e, st);
      return null;
    }
  }

  @override
  void resetSession() {
    _gameLog.info('Sesión de juego reiniciada');
    _gameChat = null;
  }

  StoryTurnResponse _parseStoryResponse(String rawText) {
    try {
      final cleaned = rawText
          .trim()
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return StoryTurnResponse.fromJson(json);
    } catch (e) {
      _gameLog.warning(
        'No se pudo parsear JSON de la respuesta, usando texto plano. Error: $e',
      );
      return StoryTurnResponse(
        story: rawText,
        choices: ['Continuar...'],
        imagePrompt: 'RPG adventure scene',
      );
    }
  }
}
