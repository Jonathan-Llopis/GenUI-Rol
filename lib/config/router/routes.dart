import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/main.dart';
import 'package:rol_genui/presentation/screens/character_creation/screen_character_creation.dart';
import 'package:rol_genui/presentation/screens/character_list/screen_character_list.dart';
import 'package:rol_genui/presentation/screens/character_sheet/screen_character_sheet.dart';
import 'package:rol_genui/presentation/screens/game_session/screen_game_session.dart';
import 'package:rol_genui/presentation/screens/home/screen_home.dart';
import 'package:rol_genui/presentation/screens/onboarding/screen_onboarding.dart';
import 'package:rol_genui/presentation/screens/settings/screen_settings.dart';
import 'package:rol_genui/presentation/screens/splash/screen_initial_loading.dart';
import 'package:rol_genui/presentation/widgets/default_app_bar.dart';

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (context, state) => const ScreenInitialLoading(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const ScreenOnboarding(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) =>
          const Scaffold(appBar: DefaultAppBar(), body: ScreenHome()),
      routes: [
        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => const ScreenSettings(),
        ),
        // Character list for a rule system
        GoRoute(
          path: 'system/:systemId/characters',
          name: 'character-list',
          builder: (context, state) {
            final systemId = RuleSystemId.values.firstWhere(
              (e) => e.name == state.pathParameters['systemId'],
            );
            final system = RuleSystem.fromId(systemId);
            return ScreenCharacterList(system: system);
          },
          routes: [
            // Create character
            GoRoute(
              path: 'create',
              name: 'character-create',
              builder: (context, state) {
                final systemId = RuleSystemId.values.firstWhere(
                  (e) => e.name == state.pathParameters['systemId'],
                );
                final system = RuleSystem.fromId(systemId);
                return ScreenCharacterCreation(system: system);
              },
            ),
            // Character sheet
            GoRoute(
              path: ':characterId/sheet',
              name: 'character-sheet',
              builder: (context, state) {
                final character = state.extra as Character;
                return ScreenCharacterSheet(character: character);
              },
            ),
            // Game session
            GoRoute(
              path: ':characterId/play',
              name: 'game-session',
              builder: (context, state) {
                final character = state.extra as Character;
                final sessionId = state.uri.queryParameters['sessionId'];
                return ScreenGameSession(
                  character: character,
                  sessionId: sessionId,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
