import 'package:equatable/equatable.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();
  @override
  List<Object?> get props => [];
}

class LoadCharactersBySystem extends CharacterEvent {
  const LoadCharactersBySystem(this.systemId);
  final RuleSystemId systemId;
  @override
  List<Object?> get props => [systemId];
}

class CreateCharacter extends CharacterEvent {
  const CreateCharacter(this.character);
  final Character character;
  @override
  List<Object?> get props => [character];
}

class UpdateCharacter extends CharacterEvent {
  const UpdateCharacter(this.character);
  final Character character;
  @override
  List<Object?> get props => [character];
}

class DeleteCharacter extends CharacterEvent {
  const DeleteCharacter(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}
