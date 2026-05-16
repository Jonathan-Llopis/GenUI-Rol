import 'package:equatable/equatable.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/combat.dart';
import 'package:rol_genui/domain/entities/game_session.dart';
import 'package:rol_genui/domain/entities/story_message.dart';

abstract class GameState extends Equatable {
  const GameState();
  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoading extends GameState {
  const GameLoading({this.message = 'Iniciando aventura...'});
  final String message;
  @override
  List<Object?> get props => [message];
}

class GameTurn extends GameState {
  const GameTurn({
    required this.session,
    required this.messages,
    required this.character,
    required this.currentChoices,
    this.combatState,
    this.sceneImageBytes,
    this.isGeneratingImage = false,
    this.isWaitingForAi = false,
  });

  final GameSession session;
  final List<StoryMessage> messages;
  final Character character;
  final List<String> currentChoices;
  final CombatState? combatState;
  final List<int>? sceneImageBytes;
  final bool isGeneratingImage;
  final bool isWaitingForAi;

  GameTurn copyWith({
    GameSession? session,
    List<StoryMessage>? messages,
    Character? character,
    List<String>? currentChoices,
    CombatState? combatState,
    List<int>? sceneImageBytes,
    bool? isGeneratingImage,
    bool? isWaitingForAi,
  }) {
    return GameTurn(
      session: session ?? this.session,
      messages: messages ?? this.messages,
      character: character ?? this.character,
      currentChoices: currentChoices ?? this.currentChoices,
      combatState: combatState ?? this.combatState,
      sceneImageBytes: sceneImageBytes ?? this.sceneImageBytes,
      isGeneratingImage: isGeneratingImage ?? this.isGeneratingImage,
      isWaitingForAi: isWaitingForAi ?? this.isWaitingForAi,
    );
  }

  @override
  List<Object?> get props => [
        session,
        messages,
        character,
        currentChoices,
        combatState,
        sceneImageBytes,
        isGeneratingImage,
        isWaitingForAi,
      ];
}

class GameError extends GameState {
  const GameError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
