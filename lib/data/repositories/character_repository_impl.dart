import 'package:rol_genui/data/datasources/database_datasource.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  const CharacterRepositoryImpl(this._db);

  final DatabaseDataSource _db;

  @override
  Future<void> createCharacter(Character character) =>
      _db.insertCharacter(character);

  @override
  Future<void> updateCharacter(Character character) =>
      _db.updateCharacter(character);

  @override
  Future<void> deleteCharacter(String id) => _db.deleteCharacter(id);

  @override
  Future<Character?> getCharacter(String id) => _db.getCharacter(id);

  @override
  Future<List<Character>> getCharactersBySystem(RuleSystemId systemId) =>
      _db.getCharactersBySystem(systemId);
}
