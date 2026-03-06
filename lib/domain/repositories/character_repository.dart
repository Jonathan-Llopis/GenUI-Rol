import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';

abstract class CharacterRepository {
  Future<void> createCharacter(Character character);
  Future<void> updateCharacter(Character character);
  Future<void> deleteCharacter(String id);
  Future<Character?> getCharacter(String id);
  Future<List<Character>> getCharactersBySystem(RuleSystemId systemId);
}
