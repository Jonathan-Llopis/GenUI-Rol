import 'package:rol_genui/domain/entities/game_session.dart';
import 'package:rol_genui/domain/entities/story_message.dart';

abstract class SessionRepository {
  Future<void> createSession(GameSession session);
  Future<void> updateSession(GameSession session);
  Future<void> deleteSession(String id);
  Future<GameSession?> getSession(String id);
  Future<List<GameSession>> getSessionsByCharacter(String characterId);
  Future<void> saveMessage(StoryMessage message);
  Future<List<StoryMessage>> getMessages(String sessionId);
}
