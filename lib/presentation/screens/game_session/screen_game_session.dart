import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:genui/genui.dart';
import 'package:genui_google_generative_ai/genui_google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/domain/entities/story_message.dart';
import 'package:rol_genui/injection.dart';
import 'package:rol_genui/presentation/blocs/game/game_bloc.dart';
import 'package:rol_genui/presentation/blocs/game/game_event.dart';
import 'package:rol_genui/presentation/blocs/game/game_state.dart';
import 'package:rol_genui/presentation/blocs/language/language_bloc.dart';
import 'package:rol_genui/presentation/screens/game_session/widgets/character_sheet_drawer.dart';

class ScreenGameSession extends StatefulWidget {
  const ScreenGameSession({super.key, required this.character});
  final Character character;

  @override
  State<ScreenGameSession> createState() => _ScreenGameSessionState();
}

class _ScreenGameSessionState extends State<ScreenGameSession> {
  late final GenUiManager _genUiManager;
  late final GoogleGenerativeAiContentGenerator _contentGenerator;
  late final GenUiConversation _genUiConversation;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    final system = widget.character.ruleSystem;

    _genUiManager = GenUiManager(catalog: CoreCatalogItems.asCatalog());
    _contentGenerator = GoogleGenerativeAiContentGenerator(
      catalog: CoreCatalogItems.asCatalog(),
      apiKey: apiKey,
      modelName: 'models/gemini-2.0-flash',
      systemInstruction: _buildGenUiSystemPrompt(system),
    );
    _genUiConversation = GenUiConversation(
      contentGenerator: _contentGenerator,
      genUiManager: _genUiManager,
    );
  }

  String _buildGenUiSystemPrompt(RuleSystem system) {
    return '''You are an RPG interface generator for ${system.name}.
Your task is to generate interactive UI components for the player's choices and character stats.
When given story choices, create a Column of Buttons (one per choice).
When showing stats, create a Row of Cards with the stat name and value.
Keep the UI compact and thematic for a ${system.genre} RPG.''';
  }

  @override
  void dispose() {
    _genUiConversation.dispose();
    _genUiManager.dispose();
    _contentGenerator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<GameBloc>();
        final locale = context.read<LanguageBloc>().state.locale;
        final langCode = locale.languageCode;
        bloc.add(StartNewGame(
          character: widget.character,
          system: widget.character.ruleSystem,
          languageCode: langCode,
        ));
        return bloc;
      },
      child: _GameSessionView(
        character: widget.character,
        genUiManager: _genUiManager,
        genUiConversation: _genUiConversation,
      ),
    );
  }
}

class _GameSessionView extends StatefulWidget {
  const _GameSessionView({
    required this.character,
    required this.genUiManager,
    required this.genUiConversation,
  });
  final Character character;
  final GenUiManager genUiManager;
  final GenUiConversation genUiConversation;

  @override
  State<_GameSessionView> createState() => _GameSessionViewState();
}

class _GameSessionViewState extends State<_GameSessionView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.character.ruleSystem.icon),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.character.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  BlocBuilder<GameBloc, GameState>(
                    builder: (_, state) => Text(
                      state is GameTurn ? state.session.title : 'Iniciando...',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          BlocBuilder<GameBloc, GameState>(
            builder: (context, state) => IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Ficha del personaje',
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          BlocBuilder<GameBloc, GameState>(
            builder: (context, state) => IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Nueva aventura',
              onPressed: state is GameLoading
                  ? null
                  : () {
                final locale = context.read<LanguageBloc>().state.locale;
                context.read<GameBloc>().add(StartNewGame(
                  character: widget.character,
                  system: widget.character.ruleSystem,
                  languageCode: locale.languageCode,
                ));
              },
            ),
          ),
        ],
      ),
      endDrawer: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          final character = state is GameTurn ? state.character : widget.character;
          return CharacterSheetDrawer(character: character);
        },
      ),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameTurn) _scrollToBottom();
        },
        builder: (context, state) {
          return switch (state) {
            GameLoading s => _LoadingView(message: s.message),
            GameError s => _ErrorView(message: s.message),
            GameTurn s => _GameTurnView(
              state: s,
              scrollController: _scrollController,
              genUiManager: widget.genUiManager,
              genUiConversation: widget.genUiConversation,
            ),
            _ => const Center(child: Text('Iniciando...')),
          };
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'El Dungeon Master está preparando la escena...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }
}

class _GameTurnView extends StatelessWidget {
  const _GameTurnView({
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Character quick stats bar
        _CharacterStatsBar(character: state.character),

        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: state.messages.length + 1, // +1 for scene image
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

        // Choice buttons (GenUI surface + fallback)
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

class _CharacterStatsBar extends StatelessWidget {
  const _CharacterStatsBar({required this.character});
  final Character character;

  @override
  Widget build(BuildContext context) {
    final system = character.ruleSystem;
    final keyStats = system.statSchema.entries
        .where((e) => e.value.type == StatType.resource)
        .where((e) => !e.key.startsWith('MAX_'))
        .take(4)
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      child: Row(
        children: [
          Text(
            character.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(width: 8),
          ...keyStats.map((e) {
            final val = character.stats[e.key] ?? 0;
            final maxKey = 'MAX_${e.key}';
            final maxVal = character.stats[maxKey];
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _StatPill(
                label: e.key,
                value: val,
                maxValue: maxVal,
                isLow: maxVal != null && val < maxVal * 0.25,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value, this.maxValue, this.isLow = false});
  final String label;
  final int value;
  final int? maxValue;
  final bool isLow;

  @override
  Widget build(BuildContext context) {
    final color = isLow ? Colors.red : Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        maxValue != null ? '$label: $value/$maxValue' : '$label: $value',
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
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
        height: 180,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceVariant,
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
      // Placeholder atmosférico cuando no hay imagen disponible
      return Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade900,
              Colors.black87,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_stories,
                  color: Colors.white.withValues(alpha: 0.3), size: 32),
              const SizedBox(height: 4),
              Text(
                'Escena sin imagen',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)],
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

    // Narrator message
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: MarkdownBody(
            data: message.text,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: Theme.of(context).textTheme.bodyMedium,
            ),
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
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, -2)),
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
  const _ChoiceButton({required this.index, required this.text, required this.character});
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          context.read<GameBloc>().add(MakeChoice(
            choice: text,
            choiceIndex: index,
            languageCode: locale.languageCode,
          ));
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
