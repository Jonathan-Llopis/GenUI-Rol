import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/domain/repositories/character_repository.dart';

class CreateCharacterUsecase {
  const CreateCharacterUsecase(this._repository);
  final CharacterRepository _repository;
  Future<void> call(Character character) =>
      _repository.createCharacter(character);
}

class UpdateCharacterUsecase {
  const UpdateCharacterUsecase(this._repository);
  final CharacterRepository _repository;
  Future<void> call(Character character) =>
      _repository.updateCharacter(character);
}

class DeleteCharacterUsecase {
  const DeleteCharacterUsecase(this._repository);
  final CharacterRepository _repository;
  Future<void> call(String id) => _repository.deleteCharacter(id);
}

class GetCharacterUsecase {
  const GetCharacterUsecase(this._repository);
  final CharacterRepository _repository;
  Future<Character?> call(String id) => _repository.getCharacter(id);
}

class GetCharactersBySystemUsecase {
  const GetCharactersBySystemUsecase(this._repository);
  final CharacterRepository _repository;
  Future<List<Character>> call(RuleSystemId systemId) =>
      _repository.getCharactersBySystem(systemId);
}
