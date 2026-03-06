import 'package:equatable/equatable.dart';
import 'package:rol_genui/domain/entities/character.dart';

abstract class CharacterState extends Equatable {
  const CharacterState();
  @override
  List<Object?> get props => [];
}

class CharacterInitial extends CharacterState {
  const CharacterInitial();
}

class CharacterLoading extends CharacterState {
  const CharacterLoading();
}

class CharactersLoaded extends CharacterState {
  const CharactersLoaded(this.characters);
  final List<Character> characters;
  @override
  List<Object?> get props => [characters];
}

class CharacterOperationSuccess extends CharacterState {
  const CharacterOperationSuccess({required this.characters, this.message});
  final List<Character> characters;
  final String? message;
  @override
  List<Object?> get props => [characters, message];
}

class CharacterError extends CharacterState {
  const CharacterError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
