import 'package:rol_genui/data/datasources/chat_datasource.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/game_session.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/domain/entities/story_message.dart';
import 'package:rol_genui/domain/repositories/session_repository.dart';
import 'package:uuid/uuid.dart';

class StartGameSessionUsecase {
  const StartGameSessionUsecase(this._repository, this._gameDataSource);

  final SessionRepository _repository;
  final GameRemoteDataSource _gameDataSource;

  Future<({GameSession session, StoryMessage firstMessage})> call({
    required Character character,
    required RuleSystem system,
    required String languageCode,
  }) async {
    _gameDataSource.resetSession();

    final response = await _gameDataSource.startGameSession(
      character: character,
      system: system,
      languageCode: languageCode,
    );

    final now = DateTime.now();
    final sessionId = const Uuid().v4();
    final session = GameSession(
      id: sessionId,
      characterId: character.id,
      ruleSystemId: system.id,
      title: response.sessionTitle ?? '${character.name} - ${system.name}',
      summary: response.story.substring(0, response.story.length.clamp(0, 200)),
      createdAt: now,
      updatedAt: now,
    );

    final message = StoryMessage(
      id: const Uuid().v4(),
      sessionId: sessionId,
      role: MessageRole.narrator,
      text: response.story,
      choices: response.choices,
      timestamp: now,
    );

    await _repository.createSession(session);
    await _repository.saveMessage(message);

    return (session: session, firstMessage: message);
  }
}

class SendGameChoiceUsecase {
  const SendGameChoiceUsecase(this._repository, this._gameDataSource);

  final SessionRepository _repository;
  final GameRemoteDataSource _gameDataSource;

  Future<({StoryMessage playerMessage, StoryMessage narratorMessage})> call({
    required String sessionId,
    required String choice,
    required int choiceIndex,
    required String languageCode,
  }) async {
    final now = DateTime.now();

    final playerMsg = StoryMessage(
      id: const Uuid().v4(),
      sessionId: sessionId,
      role: MessageRole.player,
      text: choice,
      selectedChoiceIndex: choiceIndex,
      timestamp: now,
    );

    final response = await _gameDataSource.sendGameChoice(
      choice: choice,
      languageCode: languageCode,
    );

    final narratorMsg = StoryMessage(
      id: const Uuid().v4(),
      sessionId: sessionId,
      role: MessageRole.narrator,
      text: response.story,
      choices: response.choices,
      characterUpdates: response.characterUpdates.isEmpty
          ? null
          : response.characterUpdates,
      inventoryUpdates: response.inventoryUpdates.isEmpty
          ? null
          : response.inventoryUpdates,
      combatState: response.combat,
      timestamp: now.add(const Duration(milliseconds: 1)),
    );

    await _repository.saveMessage(playerMsg);
    await _repository.saveMessage(narratorMsg);

    return (playerMessage: playerMsg, narratorMessage: narratorMsg);
  }
}

class LoadSessionUsecase {
  const LoadSessionUsecase(this._repository);
  final SessionRepository _repository;

  Future<({GameSession? session, List<StoryMessage> messages})> call(
    String sessionId,
  ) async {
    final session = await _repository.getSession(sessionId);
    final messages = await _repository.getMessages(sessionId);
    return (session: session, messages: messages);
  }
}

class GetSessionsForCharacterUsecase {
  const GetSessionsForCharacterUsecase(this._repository);
  final SessionRepository _repository;

  Future<List<GameSession>> call(String characterId) =>
      _repository.getSessionsByCharacter(characterId);
}

class DeleteSessionUsecase {
  const DeleteSessionUsecase(this._repository);
  final SessionRepository _repository;

  Future<void> call(String sessionId) => _repository.deleteSession(sessionId);
}

class GenerateSceneImageUsecase {
  const GenerateSceneImageUsecase(this._gameDataSource);
  final GameRemoteDataSource _gameDataSource;

  Future<List<int>?> call(String imagePrompt) async {
    final bytes = await _gameDataSource.generateSceneImage(imagePrompt);
    return bytes?.toList();
  }
}
