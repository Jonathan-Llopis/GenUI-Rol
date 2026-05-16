import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:llamadart/llamadart.dart';
import 'package:rol_genui/core/logging/app_logger.dart';
import 'package:rol_genui/core/prompts/game_prompt_builder.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/domain/entities/combat.dart';
import 'package:rol_genui/domain/entities/inventory.dart';

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

  LlamaEngine? get engine;
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
  LlamaEngine? _engine;
  String _history = '';
  String? _lastModelPath;

  @override
  LlamaEngine? get engine => _engine;

  Future<void> _initEngine() async {
    final modelPath = modelPathProvider();
    if (modelPath == null || modelPath.isEmpty) {
      throw Exception('No hay ningún modelo local seleccionado en ajustes.');
    }

    if (_engine != null && _lastModelPath == modelPath) return;

    _gameLog.info('Cargando motor local: $modelPath');
    try {
      if (!File(modelPath).existsSync()) {
        throw Exception('El archivo del modelo no existe en $modelPath');
      }

      _engine?.dispose();
      _engine = LlamaEngine(LlamaBackend());
      await _engine!.loadModel(modelPath);
      _lastModelPath = modelPath;
      _gameLog.info('Motor local cargado correctamente');
    } catch (e, st) {
      _gameLog.severe('Error inicializando motor local', e, st);
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

    _history = '<|im_start|>system\n$systemPrompt<|im_end|>\n<|im_start|>user\n$startPrompt<|im_end|>\n<|im_start|>assistant\n';
    return _generateAndParse();
  }

  @override
  Future<StoryTurnResponse> sendGameChoice({
    required String choice,
    required String languageCode,
  }) async {
    await _initEngine();
    final prompt = buildChoicePrompt(choice: choice, languageCode: languageCode);
    _history += '<|im_start|>user\n$prompt<|im_end|>\n<|im_start|>assistant\n';
    return _generateAndParse();
  }

  Future<StoryTurnResponse> _generateAndParse() async {
    _gameLog.info('Generando respuesta local...');
    try {
      String responseText = '';
      await for (final token in _engine!.generate(_history)) {
        responseText += token;
      }
      _history += '$responseText<|im_end|>\n';
      return _parseStoryResponse(responseText);
    } catch (e, st) {
      _gameLog.severe('Error en la inferencia local', e, st);
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
}
