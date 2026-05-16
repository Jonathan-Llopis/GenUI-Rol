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

/// Represents a single "page" in the history
class GameTurnPage {
  const GameTurnPage({
    this.playerAction,
    required this.narratorText,
    this.isLast = false,
  });
  final String? playerAction;
  final String narratorText;
  final bool isLast;
}

class GameChatView extends StatefulWidget {
  const GameChatView({
    super.key,
    required this.state,
    required this.scrollController,
    required this.genUiManager,
    required this.genUiConversation,
  });

  final GameTurn state;
  final ScrollController scrollController;
  final GenUiManager genUiManager;
  final GenUiConversation genUiConversation;

  @override
  State<GameChatView> createState() => _GameChatViewState();
}

class _GameChatViewState extends State<GameChatView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(GameChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If a new turn was added, scroll to the end
    if (widget.state.messages.length > oldWidget.state.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _getPages().length - 1,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<GameTurnPage> _getPages() {
    final List<GameTurnPage> pages = [];
    final messages = widget.state.messages;

    if (messages.isEmpty) return [];

    // First message is special (Intro)
    pages.add(GameTurnPage(
      narratorText: messages.first.text,
      isLast: messages.length == 1,
    ));

    // Subsequent pairs
    for (int i = 1; i < messages.length; i++) {
      final msg = messages[i];
      if (msg.role == MessageRole.player) {
        final String action = msg.text;
        String narratorResponse = "...";
        if (i + 1 < messages.length) {
          narratorResponse = messages[i + 1].text;
          i++; // Skip the narrator response in next iteration
        }
        pages.add(GameTurnPage(
          playerAction: action,
          narratorText: narratorResponse,
          isLast: i == messages.length - 1,
        ));
      }
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = _getPages();

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final page = pages[index];
              return _ChatPage(
                page: page,
                imageBytes: page.isLast ? widget.state.sceneImageBytes : null,
                isGeneratingImage: page.isLast && widget.state.isGeneratingImage,
                genUiManager: widget.genUiManager,
                genUiConversation: widget.genUiConversation,
              );
            },
          ),
        ),
        if (widget.state.isWaitingForAi)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (widget.state.currentChoices.isNotEmpty)
          _ChoicesPanel(
            choices: widget.state.currentChoices,
            character: widget.state.character,
          ),
      ],
    );
  }
}

class _ChatPage extends StatelessWidget {
  const _ChatPage({
    required this.page,
    this.imageBytes,
    this.isGeneratingImage = false,
    required this.genUiManager,
    required this.genUiConversation,
  });

  final GameTurnPage page;
  final List<int>? imageBytes;
  final bool isGeneratingImage;
  final GenUiManager genUiManager;
  final GenUiConversation genUiConversation;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SceneImageWidget(
            imageBytes: imageBytes,
            isLoading: isGeneratingImage,
          ),
          const SizedBox(height: 16),
          if (page.playerAction != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
              ),
              child: Text(
                'Tu acción: ${page.playerAction}',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          MarkdownBody(
            data: page.narratorText,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ),
          const SizedBox(height: 16),
          // Usando genUiConversation.host que es un GenUiHost válido para GenUiSurface
          if (page.isLast)
            GenUiSurface(
              surfaceId: 'active_game_surface',
              host: genUiConversation.host,
            ),
          const SizedBox(height: 100), // Spacing for choices panel
        ],
      ),
    );
  }
}

class _SceneImageWidget extends StatelessWidget {
  const _SceneImageWidget({this.imageBytes, this.isLoading = false});
  final List<int>? imageBytes;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('El DM está visualizando la escena...', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }

    if (imageBytes == null) {
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade900, Colors.black87],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_stories, color: Colors.white.withAlpha(50), size: 40),
              const SizedBox(height: 8),
              Text(
                'Crónica de la aventura',
                style: TextStyle(color: Colors.white.withAlpha(50), fontSize: 11, letterSpacing: 2),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.memory(
        Uint8List.fromList(imageBytes!),
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ChoicesPanel extends StatelessWidget {
  const _ChoicesPanel({
    required this.choices,
    required this.character,
  });
  final List<String> choices;
  final Character character;

  void _showCustomActionDialog(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Qué quieres intentar?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe tu acción con tus propias palabras...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isNotEmpty) {
                    final locale = context.read<LanguageBloc>().state.locale;
                    context.read<GameBloc>().add(MakeChoice(
                          choice: text,
                          choiceIndex: -1,
                          languageCode: locale.languageCode,
                        ));
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('Enviar acción'),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TU TURNO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          // Suggested choices
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
          // Custom action button
          const SizedBox(height: 4),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
            ),
            onPressed: () => _showCustomActionDialog(context),
            icon: const Icon(Icons.edit_note, size: 20),
            label: const Text('Otra acción...', style: TextStyle(fontSize: 13)),
          ),
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
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        child: Text(text, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}
