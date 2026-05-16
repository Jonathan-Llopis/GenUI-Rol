import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rol_genui/core/logging/app_logger.dart';
import 'package:rol_genui/domain/entities/item.dart';
import 'package:rol_genui/domain/usecases/character_usecases/character_usecases.dart';
import 'package:rol_genui/domain/usecases/session_usecases/session_usecases.dart';
import 'package:rol_genui/presentation/blocs/game/game_event.dart';
import 'package:rol_genui/presentation/blocs/game/game_state.dart';

final _log = getLogger('GameBloc');

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required this.startGameSessionUsecase,
    required this.sendGameChoiceUsecase,
    required this.loadSessionUsecase,
    required this.generateSceneImageUsecase,
    required this.updateCharacterUsecase,
  }) : super(const GameInitial()) {
    on<StartNewGame>(_onStartNewGame);
    on<MakeChoice>(_onMakeChoice);
    on<LoadExistingSession>(_onLoadExistingSession);
    on<RequestSceneImage>(_onRequestSceneImage);
    on<ResetGame>(_onResetGame);
    on<UpdateCharacter>(_onUpdateCharacter);
  }

  final StartGameSessionUsecase startGameSessionUsecase;
  final SendGameChoiceUsecase sendGameChoiceUsecase;
  final LoadSessionUsecase loadSessionUsecase;
  final GenerateSceneImageUsecase generateSceneImageUsecase;
  final UpdateCharacterUsecase updateCharacterUsecase;

  Future<void> _onStartNewGame(
    StartNewGame event,
    Emitter<GameState> emit,
  ) async {
    _log.info(
      'StartNewGame: personaje="${event.character.name}" sistema=${event.system.id.name}',
    );
    emit(
      const GameLoading(
        message: 'El Dungeon Master está preparando la aventura...',
      ),
    );
    try {
      final result = await startGameSessionUsecase(
        character: event.character,
        system: event.system,
        languageCode: event.languageCode,
      );

      _log.info('Nueva sesión creada: id=${result.session.id}');
      final turnState = GameTurn(
        session: result.session,
        messages: [result.firstMessage],
        character: event.character,
        currentChoices: result.firstMessage.choices ?? [],
        combatState: result.firstMessage.combatState,
        isGeneratingImage: true,
      );
      emit(turnState);

      if (result.firstMessage.choices != null) {
        add(RequestSceneImage('${event.system.genre} RPG opening scene'));
      }
    } catch (e, st) {
      _log.severe('Error al iniciar la aventura', e, st);
      emit(GameError('Error al iniciar la aventura: $e'));
    }
  }

  Future<void> _onMakeChoice(MakeChoice event, Emitter<GameState> emit) async {
    final currentState = state;
    if (currentState is! GameTurn) {
      _log.warning(
        'MakeChoice ignorado: estado actual no es GameTurn (${state.runtimeType})',
      );
      return;
    }

    _log.info('MakeChoice: "${event.choice}" (índice ${event.choiceIndex})');
    emit(currentState.copyWith(isWaitingForAi: true, currentChoices: []));

    try {
      final result = await sendGameChoiceUsecase(
        sessionId: currentState.session.id,
        choice: event.choice,
        choiceIndex: event.choiceIndex,
        languageCode: event.languageCode,
      );

      var updatedCharacter = currentState.character;
      final msg = result.narratorMessage;

      // 1. Stats updates
      if (msg.characterUpdates != null) {
        final updates = msg.characterUpdates!;
        _log.fine('Aplicando actualizaciones de estadísticas: $updates');
        final newStats = Map<String, int>.from(updatedCharacter.stats);
        updates.forEach((key, delta) {
          if (newStats.containsKey(key)) {
            final maxKey = 'MAX_$key';
            final maxVal = newStats[maxKey] ?? newStats[key]!;
            newStats[key] = (newStats[key]! + delta).clamp(0, maxVal);
          }
        });
        updatedCharacter = updatedCharacter.copyWith(stats: newStats);
      }

      // 2. Inventory updates
      if (msg.inventoryUpdates != null && msg.inventoryUpdates!.isNotEmpty) {
        _log.info(
          'Procesando ${msg.inventoryUpdates!.length} actualizaciones de inventario',
        );
        var newInventory = List<Item>.from(updatedCharacter.inventory);
        for (final up in msg.inventoryUpdates!) {
          if (up.action == 'add' && up.item != null) {
            newInventory.add(up.item!);
            _log.info('Objeto añadido: ${up.item!.name}');
          } else if (up.action == 'remove' && up.itemId != null) {
            newInventory.removeWhere((item) => item.id == up.itemId);
            _log.info('Objeto eliminado: id=${up.itemId}');
          }
        }
        updatedCharacter = updatedCharacter.copyWith(inventory: newInventory);
      }

      // 3. Persist character if changed
      if (updatedCharacter != currentState.character) {
        updatedCharacter = updatedCharacter.copyWith(updatedAt: DateTime.now());
        updateCharacterUsecase.call(updatedCharacter);
        _log.info('Ficha del personaje guardada con cambios');
      }

      final updatedMessages = [
        ...currentState.messages,
        result.playerMessage,
        msg,
      ];

      final newTurnState = GameTurn(
        session: currentState.session,
        messages: updatedMessages,
        character: updatedCharacter,
        currentChoices: msg.choices ?? [],
        combatState: msg.combatState,
        isGeneratingImage: true,
      );
      emit(newTurnState);
      _log.fine(
        'Nuevo turno emitido. Total mensajes: ${updatedMessages.length}',
      );

      add(
        RequestSceneImage(msg.text.substring(0, msg.text.length.clamp(0, 150))),
      );
    } catch (e, st) {
      _log.severe('Error al procesar elección', e, st);
      emit(GameError('Error al procesar la elección: $e'));
    }
  }

  Future<void> _onLoadExistingSession(
    LoadExistingSession event,
    Emitter<GameState> emit,
  ) async {
    _log.info('LoadExistingSession: id=${event.sessionId}');
    emit(const GameLoading(message: 'Cargando sesión...'));
    try {
      final result = await loadSessionUsecase(event.sessionId);
      if (result.session == null) {
        _log.warning('Sesión no encontrada: id=${event.sessionId}');
        emit(const GameError('Sesión no encontrada'));
        return;
      }
      _log.info(
        'Sesión cargada: "${result.session!.title}" con ${result.messages.length} mensajes',
      );
      emit(
        GameTurn(
          session: result.session!,
          messages: result.messages,
          character: event.character,
          currentChoices: result.messages.isNotEmpty
              ? (result.messages.last.choices ?? [])
              : [],
          combatState: result.messages.isNotEmpty
              ? result.messages.last.combatState
              : null,
        ),
      );
    } catch (e, st) {
      _log.severe('Error al cargar sesión id=${event.sessionId}', e, st);
      emit(GameError('Error al cargar la sesión: $e'));
    }
  }

  Future<void> _onRequestSceneImage(
    RequestSceneImage event,
    Emitter<GameState> emit,
  ) async {
    final currentState = state;
    if (currentState is! GameTurn) return;

    _log.fine(
      'RequestSceneImage: "${event.imagePrompt.substring(0, event.imagePrompt.length.clamp(0, 60))}"',
    );
    try {
      final imageBytes = await generateSceneImageUsecase(event.imagePrompt);
      if (imageBytes != null) {
        _log.info('Imagen de escena recibida (${imageBytes.length} bytes)');
      } else {
        _log.warning('No se obtuvo imagen de escena');
      }
      emit(
        currentState.copyWith(
          sceneImageBytes: imageBytes,
          isGeneratingImage: false,
        ),
      );
    } catch (e, st) {
      _log.warning('Error generando imagen de escena', e, st);
      emit(currentState.copyWith(isGeneratingImage: false));
    }
  }

  void _onResetGame(ResetGame event, Emitter<GameState> emit) {
    _log.info('ResetGame: volviendo a GameInitial');
    emit(const GameInitial());
  }

  Future<void> _onUpdateCharacter(
    UpdateCharacter event,
    Emitter<GameState> emit,
  ) async {
    final current = state;
    if (current is! GameTurn) return;
    _log.info(
      'UpdateCharacter: "${event.character.name}" — inventario: ${event.character.inventory.length} objetos',
    );
    try {
      await updateCharacterUsecase(event.character);
      emit(current.copyWith(character: event.character));
    } catch (e, st) {
      _log.severe('Error actualizando personaje', e, st);
    }
  }
}
