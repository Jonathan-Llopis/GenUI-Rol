import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:rol_genui/data/datasources/chat_datasource.dart';
import 'package:rol_genui/data/datasources/local_llama_content_generator.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/injection.dart';
import 'package:rol_genui/presentation/blocs/game/game_bloc.dart';
import 'package:rol_genui/presentation/blocs/game/game_event.dart';
import 'package:rol_genui/presentation/blocs/game/game_state.dart';
import 'package:rol_genui/presentation/blocs/language/language_bloc.dart';

import 'package:rol_genui/presentation/screens/game_session/widgets/game_character_view.dart';
import 'package:rol_genui/presentation/screens/game_session/widgets/game_chat_view.dart';
import 'package:rol_genui/presentation/screens/game_session/widgets/game_combat_view.dart';
import 'package:rol_genui/presentation/screens/game_session/widgets/game_inventory_view.dart';

class ScreenGameSession extends StatefulWidget {
  const ScreenGameSession({super.key, required this.character});
  final Character character;

  @override
  State<ScreenGameSession> createState() => _ScreenGameSessionState();
}

class _ScreenGameSessionState extends State<ScreenGameSession> {
  late final GenUiManager _genUiManager;
  LocalLlamaContentGenerator? _contentGenerator;
  GenUiConversation? _genUiConversation;

  @override
  void initState() {
    super.initState();
    _genUiManager = GenUiManager(catalog: CoreCatalogItems.asCatalog());
  }

  void _initGenUiWithEngine() {
    if (_contentGenerator != null) return;

    final dataSource = sl<GameRemoteDataSource>();
    final engine = dataSource.engine;

    if (engine != null) {
      _contentGenerator = LocalLlamaContentGenerator(
        engine: engine,
        systemInstruction: _buildGenUiSystemPrompt(widget.character.ruleSystem),
      );
      _genUiConversation = GenUiConversation(
        contentGenerator: _contentGenerator!,
        genUiManager: _genUiManager,
      );
      // Actualiza la UI para pasar el conversador una vez creado
      if (mounted) setState(() {});
    }
  }

  String _buildGenUiSystemPrompt(RuleSystem system) {
    return '''You are an RPG interface generator for ${system.name}.
Your task is to generate interactive UI components for the player's choices and character stats.
Keep the UI thematic for a ${system.genre} RPG.''';
  }

  @override
  void dispose() {
    _genUiConversation?.dispose();
    _contentGenerator?.dispose();
    _genUiManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<GameBloc>();
        final locale = context.read<LanguageBloc>().state.locale;
        final langCode = locale.languageCode;
        bloc.add(
          StartNewGame(
            character: widget.character,
            system: widget.character.ruleSystem,
            languageCode: langCode,
          ),
        );
        return bloc;
      },
      child: BlocListener<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameTurn) {
            _initGenUiWithEngine();
          }
        },
        child: _GameSessionView(
          character: widget.character,
          genUiManager: _genUiManager,
          genUiConversation: _genUiConversation,
        ),
      ),
    );
  }
}

class _GameSessionView extends StatefulWidget {
  const _GameSessionView({
    required this.character,
    required this.genUiManager,
    this.genUiConversation,
  });
  final Character character;
  final GenUiManager genUiManager;
  final GenUiConversation? genUiConversation;

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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    BlocBuilder<GameBloc, GameState>(
                      builder: (_, state) => Text(
                        state is GameTurn
                            ? state.session.title
                            : 'Iniciando...',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                        ),
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
                icon: const Icon(Icons.refresh),
                tooltip: 'Nueva aventura',
                onPressed: state is GameLoading
                    ? null
                    : () {
                        final locale = context
                            .read<LanguageBloc>()
                            .state
                            .locale;
                        context.read<GameBloc>().add(
                          StartNewGame(
                            character: widget.character,
                            system: widget.character.ruleSystem,
                            languageCode: locale.languageCode,
                          ),
                        );
                      },
              ),
            ),
          ],
        ),
        body: BlocConsumer<GameBloc, GameState>(
          listener: (context, state) {
            if (state is GameTurn) _scrollToBottom();
          },
          builder: (context, state) {
            return switch (state) {
              GameLoading s => _LoadingView(message: s.message),
              GameError s => _ErrorView(message: s.message),
              GameTurn s => TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (widget.genUiConversation != null)
                    GameChatView(
                      state: s,
                      scrollController: _scrollController,
                      genUiManager: widget.genUiManager,
                      genUiConversation: widget.genUiConversation!,
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                  GameCharacterView(character: s.character),
                  GameInventoryView(character: s.character),
                  GameCombatView(
                    combatState: s.combatState,
                    character: s.character,
                  ),
                ],
              ),
              _ => const Center(child: Text('Iniciando...')),
            };
          },
        ),
        bottomNavigationBar: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is! GameTurn) return const SizedBox.shrink();
            return Container(
              color: Theme.of(context).colorScheme.surface,
              child: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Historia'),
                  Tab(icon: Icon(Icons.person_outline), text: 'Ficha'),
                  Tab(
                    icon: Icon(Icons.inventory_2_outlined),
                    text: 'Inventario',
                  ),
                  Tab(icon: Icon(Icons.shield_outlined), text: 'Combate'),
                ],
                labelStyle: TextStyle(fontSize: 10),
                indicatorSize: TabBarIndicatorSize.label,
              ),
            );
          },
        ),
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
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
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
