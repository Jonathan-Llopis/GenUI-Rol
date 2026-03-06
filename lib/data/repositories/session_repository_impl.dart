import 'package:rol_genui/data/datasources/database_datasource.dart';
import 'package:rol_genui/domain/entities/game_session.dart';
import 'package:rol_genui/domain/entities/story_message.dart';
import 'package:rol_genui/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl(this._db);

  final DatabaseDataSource _db;

  @override
  Future<void> createSession(GameSession session) => _db.insertSession(session);

  @override
  Future<void> updateSession(GameSession session) => _db.updateSession(session);

  @override
  Future<void> deleteSession(String id) => _db.deleteSession(id);

  @override
  Future<GameSession?> getSession(String id) => _db.getSession(id);

  @override
  Future<List<GameSession>> getSessionsByCharacter(String characterId) =>
      _db.getSessionsByCharacter(characterId);

  @override
  Future<void> saveMessage(StoryMessage message) => _db.insertMessage(message);

  @override
  Future<List<StoryMessage>> getMessages(String sessionId) =>
      _db.getMessagesBySession(sessionId);
}
