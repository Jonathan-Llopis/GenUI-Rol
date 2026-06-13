import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:rol_genui/core/logging/app_logger.dart';
import 'package:rol_genui/core/prompts/game_prompt_builder.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/domain/entities/combat.dart';
import 'package:rol_genui/domain/entities/inventory.dart';
import 'package:rol_genui/domain/entities/story_message.dart';

final _gameLog = getLogger('LocalGameDataSource');

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

  void initializeHistory({
    required Character character,
    required RuleSystem system,
    required String languageCode,
    required List<StoryMessage> messages,
  });

  InferenceModel? get engine;
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
      choices: (json['choices'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      imagePrompt: json['image_prompt'] as String? ?? '',
      characterUpdates: (json['character_updates'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toInt()),
          ) ??
          {},
      inventoryUpdates: (json['inventory_updates'] as List<dynamic>?)
              ?.map((e) => InventoryUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      combat: json['combat'] != null ? CombatState.fromJson(json['combat'] as Map<String, dynamic>) : null,
      sessionTitle: json['session_title'] as String?,
    );
  }
}

class LocalGameDataSourceImpl implements GameRemoteDataSource {
  LocalGameDataSourceImpl({required this.modelPathProvider});

  final String? Function() modelPathProvider;
  InferenceModel? _engine;
  InferenceModelSession? _activeSession;
  String _history = '';
  String? _lastModelPath;

  @override
  InferenceModel? get engine => _engine;

  Future<void> _initEngine() async {
    final modelPath = modelPathProvider();
    if (modelPath == null || modelPath.isEmpty) {
      throw Exception('No hay ningún modelo local seleccionado en ajustes.');
    }

    if (modelPath.endsWith('.gguf')) {
      throw Exception(
        'El modelo seleccionado está en formato GGUF (.gguf), el cual no es compatible con el nuevo motor por GPU (MediaPipe).\n\n'
        'Por favor, ve a Ajustes y descarga uno de los nuevos modelos recomendados (.litertlm o .bin).'
      );
    }

    if (_engine != null && _lastModelPath == modelPath) return;

    _gameLog.info('Cargando motor local: $modelPath');
    try {
      if (!File(modelPath).existsSync()) {
        throw Exception('El archivo del modelo no existe en $modelPath');
      }

      final type = getModelTypeFromPath(modelPath);

      final ModelFileType fileType;
      if (modelPath.endsWith('.litertlm')) {
        fileType = ModelFileType.litertlm;
      } else if (modelPath.endsWith('.bin') || modelPath.endsWith('.tflite')) {
        fileType = ModelFileType.binary;
      } else {
        fileType = ModelFileType.task;
      }

      _gameLog.info('Instalando modelo de tipo: $type con fileType: $fileType desde ruta: $modelPath');
      await FlutterGemma.installModel(
        modelType: type,
        fileType: fileType,
      ).fromFile(modelPath).install();

      _engine = await FlutterGemma.getActiveModel(
        maxTokens: 2048,
        preferredBackend: PreferredBackend.cpu,
      );

      _lastModelPath = modelPath;
      _gameLog.info('Motor local cargado correctamente con flutter_gemma');
    } catch (e, st) {
      _gameLog.severe('Error inicializando motor local con flutter_gemma', e, st);
      rethrow;
    }
  }

  @override
  Future<StoryTurnResponse> startGameSession({
    required Character character,
    required RuleSystem system,
    required String languageCode,
  }) async {
    await _initEngine();
    resetSession();

    final systemPrompt = buildSystemPrompt(
      character: character,
      system: system,
      languageCode: languageCode,
      isCompact: true,
    );

    final startPrompt = buildStartGamePrompt(
      system: system,
      languageCode: languageCode,
    );

    final firstPrompt = '<start_of_turn>user\n$systemPrompt\n\n$startPrompt<end_of_turn>\n<start_of_turn>model\n';
    _history = firstPrompt;
    return _generateAndParse(firstPrompt);
  }

  @override
  Future<StoryTurnResponse> sendGameChoice({
    required String choice,
    required String languageCode,
  }) async {
    await _initEngine();
    final prompt = buildChoicePrompt(choice: choice, languageCode: languageCode);
    final formattedPrompt = '<start_of_turn>user\n$prompt<end_of_turn>\n<start_of_turn>model\n';
    _history += formattedPrompt;
    return _generateAndParse(formattedPrompt);
  }

  Future<StoryTurnResponse> _generateAndParse(String newPrompt) async {
    _gameLog.info('Generando respuesta local...');
    try {
      if (_engine == null) {
        throw Exception('El motor local no está inicializado.');
      }

      final bool isNewSession = _activeSession == null;
      if (isNewSession) {
        _gameLog.info('Creando nueva sesión de inferencia...');
        _activeSession = await _engine!.createSession(
          temperature: 0.7,
          topK: 40,
        );
      }

      final queryText = isNewSession ? _history : newPrompt;
      _gameLog.info('Añadiendo consulta de entrada (tamaño prompt: ${queryText.length} caracteres, isNewSession: $isNewSession)...');
      await _activeSession!.addQueryChunk(Message.text(text: queryText, isUser: true));
      
      _gameLog.info('Iniciando stream de tokens desde el modelo...');
      String responseText = '';
      int tokenCount = 0;
      final stopwatch = Stopwatch()..start();
      
      await for (final token in _activeSession!.getResponseAsync()) {
        tokenCount++;
        responseText += token;
        if (tokenCount % 10 == 0 || tokenCount == 1) {
          _gameLog.fine('Generados $tokenCount tokens...');
        }
      }
      stopwatch.stop();
      
      _gameLog.info('Generación completada con éxito: $tokenCount tokens en ${stopwatch.elapsedMilliseconds}ms (~${(tokenCount / (stopwatch.elapsedMilliseconds / 1000)).toStringAsFixed(1)} tokens/seg).');
      _history += '$responseText<end_of_turn>\n';
      return _parseStoryResponse(responseText);
    } catch (e, st) {
      _gameLog.severe('Error en la inferencia local', e, st);
      resetSession();
      rethrow;
    }
  }

  @override
  Future<Uint8List?> generateSceneImage(String imagePrompt) async {
    try {
      final seed = imagePrompt.codeUnits.fold(0, (a, b) => (a * 31 + b) & 0x7FFFFFFF) % 1000;
      final uri = Uri.parse('https://picsum.photos/seed/$seed/512/256');
      final request = await HttpClient().getUrl(uri);
      final response = await request.close();
      final bytes = await response.fold<List<int>>([], (a, b) => a..addAll(b));
      return Uint8List.fromList(bytes);
    } catch (e) {
      return null;
    }
  }

  @override
  void resetSession() {
    _history = '';
    _gameLog.info('Sesión local reiniciada');
    if (_activeSession != null) {
      _gameLog.info('Cerrando sesión de inferencia activa en resetSession...');
      try {
        _activeSession!.close();
      } catch (e) {
        _gameLog.warning('Error al cerrar la sesión activa en resetSession: $e');
      }
      _activeSession = null;
    }
  }

  @override
  void initializeHistory({
    required Character character,
    required RuleSystem system,
    required String languageCode,
    required List<StoryMessage> messages,
  }) {
    resetSession();

    if (messages.isEmpty) return;

    final systemPrompt = buildSystemPrompt(
      character: character,
      system: system,
      languageCode: languageCode,
      isCompact: true,
    );

    final startPrompt = buildStartGamePrompt(
      system: system,
      languageCode: languageCode,
    );

    String history = '<start_of_turn>user\n$systemPrompt\n\n$startPrompt<end_of_turn>\n<start_of_turn>model\n';

    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      if (msg.role == MessageRole.narrator) {
        history += '${msg.text}<end_of_turn>\n';
      } else if (msg.role == MessageRole.player) {
        final choicePrompt = buildChoicePrompt(choice: msg.text, languageCode: languageCode);
        history += '<start_of_turn>user\n$choicePrompt<end_of_turn>\n<start_of_turn>model\n';
      }
    }

    _history = history;
    _gameLog.info('Historial de juego inicializado. Mensajes cargados: ${messages.length}. Longitud del prompt: ${_history.length} chars.');
  }

  StoryTurnResponse _parseStoryResponse(String rawText) {
    try {
      // Busca el primer '{' y el último '}' para aislar el objeto JSON
      final start = rawText.indexOf('{');
      final end = rawText.lastIndexOf('}');

      if (start != -1 && end != -1 && end > start) {
        final jsonStr = rawText.substring(start, end + 1).trim();
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        return StoryTurnResponse.fromJson(json);
      }

      throw Exception('No valid JSON block found');
    } catch (e) {
      _gameLog.warning('Error parseando JSON local, usando fallback texto plano: $e');
      return StoryTurnResponse(
        story: rawText,
        choices: ['Continuar...'],
        imagePrompt: 'RPG adventure scene',
      );
    }
  }

  static ModelType getModelTypeFromPath(String modelPath) {
    final lowerPath = modelPath.toLowerCase();
    if (lowerPath.contains('gemma-4') || lowerPath.contains('gemma4')) {
      return ModelType.gemma4;
    } else if (lowerPath.contains('function-gemma') || lowerPath.contains('functiongemma')) {
      return ModelType.functionGemma;
    } else if (lowerPath.contains('gemma')) {
      return ModelType.gemmaIt;
    } else {
      throw Exception(
        'El modelo seleccionado no es compatible.\n\n'
        'Esta aplicación solo permite el uso de modelos de la familia Gemma (Gemma 3, Gemma 4, Gemma 2, etc.) cargados a través de flutter_gemma.'
      );
    }
  }
}
