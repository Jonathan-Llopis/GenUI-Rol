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
  bool _isChoicesExpanded = false;

  @override
  void didUpdateWidget(GameChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If a new turn was added, collapse choices panel so it starts hidden
    if (widget.state.messages.length > oldWidget.state.messages.length) {
      _isChoicesExpanded = false;
    }
    // If a new turn was added, or we started/stopped waiting for AI, auto-scroll to the bottom
    if (widget.state.messages.length > oldWidget.state.messages.length ||
        widget.state.isWaitingForAi != oldWidget.state.isWaitingForAi) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            widget.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
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

    return Stack(
      children: [
        Positioned.fill(
          child: ListView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            itemCount: pages.length + 2, // Header (Scene image) + Pages + Spacing spacer at bottom
            itemBuilder: (context, index) {
              if (index == 0) {
                // Header scene cover image
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _SceneImageWidget(
                    imageBytes: widget.state.sceneImageBytes,
                    isLoading: widget.state.isGeneratingImage,
                  ),
                );
              } else if (index == pages.length + 1) {
                // Bottom spacing spacer so text can scroll above the choices panel
                final spacing = widget.state.currentChoices.isNotEmpty 
                    ? (_isChoicesExpanded ? 400.0 : 100.0) 
                    : 100.0;
                return SizedBox(height: spacing);
              }

              final pageIndex = index - 1;
              final page = pages[pageIndex];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Player Action Bubble
                  if (page.playerAction != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(left: 48, bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(4),
                          ),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'TÚ',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              page.playerAction!,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Narrator Response Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'NARRADOR',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.auto_awesome,
                              size: 10,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        MarkdownBody(
                          data: page.narratorText,
                          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                            p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.6,
                                  fontSize: 14.5,
                                ),
                          ),
                        ),
                        if (page.isLast) ...[
                          const SizedBox(height: 12),
                          GenUiSurface(
                            surfaceId: 'active_game_surface',
                            host: widget.genUiConversation.host,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Floating Choices Panel / Loading Indicator at Bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.state.isWaitingForAi)
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text(
                          'El narrador está escribiendo la crónica...',
                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                )
              else if (widget.state.currentChoices.isNotEmpty)
                _ChoicesPanel(
                  choices: widget.state.currentChoices,
                  character: widget.state.character,
                  isExpanded: _isChoicesExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isChoicesExpanded = expanded;
                    });
                    if (expanded) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (widget.scrollController.hasClients) {
                          widget.scrollController.animateTo(
                            widget.scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      });
                    }
                  },
                ),
            ],
          ),
        ),
      ],
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
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.memory(
        Uint8List.fromList(imageBytes!),
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ChoicesPanel extends StatefulWidget {
  const _ChoicesPanel({
    required this.choices,
    required this.character,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  final List<String> choices;
  final Character character;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  @override
  State<_ChoicesPanel> createState() => _ChoicesPanelState();
}

class _ChoicesPanelState extends State<_ChoicesPanel> {
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => widget.onExpansionChanged(!widget.isExpanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${widget.choices.length} opciones',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    widget.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          if (widget.isExpanded) ...[
            const SizedBox(height: 12),
            // Suggested choices
            ...widget.choices.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ChoiceButton(
                  index: entry.key,
                  text: entry.value,
                  character: widget.character,
                ),
              );
            }),
            // Custom action button
            const SizedBox(height: 4),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                ),
              ),
              onPressed: () => _showCustomActionDialog(context),
              icon: const Icon(Icons.edit_note, size: 20),
              label: const Text('Otra acción...', style: TextStyle(fontSize: 13)),
            ),
          ],
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
