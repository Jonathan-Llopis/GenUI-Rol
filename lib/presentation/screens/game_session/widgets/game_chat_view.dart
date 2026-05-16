import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:genui/genui.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/story_message.dart';
import 'package:rol_genui/presentation/blocs/game/game_bloc.dart';
import 'package:rol_genui/presentation/blocs/game/game_event.dart';
import 'package:rol_genui/presentation/blocs/game/game_state.dart';
import 'package:rol_genui/presentation/blocs/language/language_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';

class GameChatView extends StatelessWidget {
  const GameChatView({
    super.key,
    required this.state,
    required this.scrollController,
    required this.genUiManager,
  });

  final GameTurn state;
  final ScrollController scrollController;
  final GenUiManager genUiManager;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: state.messages.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _SceneImageWidget(
                  imageBytes: state.sceneImageBytes,
                  isLoading: state.isGeneratingImage,
                );
              }
              final message = state.messages[index - 1];
              return _MessageBubble(message: message);
            },
          ),
        ),
        if (state.isWaitingForAi)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state.currentChoices.isNotEmpty)
          _ChoicesPanel(
            choices: state.currentChoices,
            character: state.character,
            genUiManager: genUiManager,
          ),
      ],
    );
  }
}

// Copying necessary private widgets from screen_game_session.dart
// (Will remove them from screen_game_session.dart later)

class _SceneImageWidget extends StatelessWidget {
  const _SceneImageWidget({this.imageBytes, this.isLoading = false});
  final List<int>? imageBytes;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Generando imagen...', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }

    if (imageBytes == null) {
      return Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade900, Colors.black87],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_stories,
                color: Colors.white.withAlpha(76),
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                'Escena sin imagen',
                style: TextStyle(
                  color: Colors.white.withAlpha(76),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.memory(
        Uint8List.fromList(imageBytes!),
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final StoryMessage message;

  @override
  Widget build(BuildContext context) {
    final isPlayer = message.role == MessageRole.player;
    final isSystem = message.role == MessageRole.system;

    if (isSystem) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            message.text,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    if (isPlayer) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(message.text),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: MarkdownBody(
            data: message.text,
            styleSheet: MarkdownStyleSheet.fromTheme(
              Theme.of(context),
            ).copyWith(p: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ),
    );
  }
}

class _ChoicesPanel extends StatelessWidget {
  const _ChoicesPanel({
    required this.choices,
    required this.character,
    required this.genUiManager,
  });
  final List<String> choices;
  final Character character;
  final GenUiManager genUiManager;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '¿Qué haces?',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          ...choices.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ChoiceButton(
                index: entry.key,
                text: entry.value,
                character: character,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.index,
    required this.text,
    required this.character,
  });
  final int index;
  final String text;
  final Character character;

  @override
  Widget build(BuildContext context) {
    final locale = context.read<LanguageBloc>().state.locale;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          context.read<GameBloc>().add(
            MakeChoice(
              choice: text,
              choiceIndex: index,
              languageCode: locale.languageCode,
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
