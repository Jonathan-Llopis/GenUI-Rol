import 'package:equatable/equatable.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
  @override
  List<Object?> get props => [];
}

class StartNewGame extends GameEvent {
  const StartNewGame({
    required this.character,
    required this.system,
    required this.languageCode,
  });
  final Character character;
  final RuleSystem system;
  final String languageCode;
  @override
  List<Object?> get props => [character, system, languageCode];
}

class MakeChoice extends GameEvent {
  const MakeChoice({
    required this.choice,
    required this.choiceIndex,
    required this.languageCode,
  });
  final String choice;
  final int choiceIndex;
  final String languageCode;
  @override
  List<Object?> get props => [choice, choiceIndex, languageCode];
}

class LoadExistingSession extends GameEvent {
  const LoadExistingSession({
    required this.sessionId,
    required this.character,
    required this.languageCode,
  });
  final String sessionId;
  final Character character;
  final String languageCode;
  @override
  List<Object?> get props => [sessionId, character, languageCode];
}

class RequestSceneImage extends GameEvent {
  const RequestSceneImage(this.imagePrompt);
  final String imagePrompt;
  @override
  List<Object?> get props => [imagePrompt];
}

class ResetGame extends GameEvent {
  const ResetGame();
}

class UpdateCharacter extends GameEvent {
  const UpdateCharacter(this.character);
  final Character character;
  @override
  List<Object?> get props => [character];
}
