import 'package:flutter_test/flutter_test.dart';
import 'package:rol_genui/core/prompts/game_prompt_builder.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';

void main() {
  group('Prompt Builder RPG System Specific Tests', () {
    final now = DateTime.now();

    test('buildSystemPrompt D&D 5e contains custom mechanics and updates', () {
      final character = Character(
        id: '1',
        name: 'Grom',
        ruleSystemId: RuleSystemId.dnd5e,
        stats: {'STR': 15, 'DEX': 10, 'CON': 14, 'INT': 8, 'WIS': 12, 'CHA': 10, 'HP': 12, 'MAX_HP': 12},
        backstory: 'A brave warrior.',
        characterClass: 'Guerrero',
        race: 'Humano',
        createdAt: now,
        updatedAt: now,
      );

      final promptCompact = buildSystemPrompt(
        character: character,
        system: RuleSystem.fromId(RuleSystemId.dnd5e),
        languageCode: 'es',
        isCompact: true,
      );

      expect(promptCompact, contains('MECÁNICAS D&D 5e COMPACTAS:'));
      expect(promptCompact, contains('Ventaja'));
      expect(promptCompact, contains('"HP", "XP", "LEVEL"'));

      final promptStandard = buildSystemPrompt(
        character: character,
        system: RuleSystem.fromId(RuleSystemId.dnd5e),
        languageCode: 'es',
        isCompact: false,
      );

      expect(promptStandard, contains('MECÁNICAS DE JUEGO (D&D 5e):'));
      expect(promptStandard, contains('Escala de dificultad de CD'));
    });

    test('buildSystemPrompt Pathfinder 2e contains custom degrees of success and combat actions', () {
      final character = Character(
        id: '2',
        name: 'Kyra',
        ruleSystemId: RuleSystemId.pathfinder2e,
        stats: {'STR': 12, 'DEX': 14, 'CON': 12, 'INT': 10, 'WIS': 16, 'CHA': 14, 'HP': 18, 'MAX_HP': 18, 'HERO_POINTS': 1},
        backstory: 'A devout cleric.',
        characterClass: 'Clérigo',
        race: 'Humano',
        createdAt: now,
        updatedAt: now,
      );

      final promptCompact = buildSystemPrompt(
        character: character,
        system: RuleSystem.fromId(RuleSystemId.pathfinder2e),
        languageCode: 'es',
        isCompact: true,
      );

      expect(promptCompact, contains('MECÁNICAS PATHFINDER 2e COMPACTAS:'));
      expect(promptCompact, contains('4 Grados de Éxito'));
      expect(promptCompact, contains('3 acciones'));
      expect(promptCompact, contains('"HP", "HERO_POINTS", "LEVEL"'));

      final promptStandard = buildSystemPrompt(
        character: character,
        system: RuleSystem.fromId(RuleSystemId.pathfinder2e),
        languageCode: 'es',
        isCompact: false,
      );

      expect(promptStandard, contains('MECÁNICAS DE JUEGO (Pathfinder 2e):'));
      expect(promptStandard, contains('Éxito Crítico'));
      expect(promptStandard, contains('HERO_POINTS'));
    });

    test('buildSystemPrompt Call of Cthulhu 7e contains custom d100 success scales and temporary insanity rules', () {
      final character = Character(
        id: '3',
        name: 'Dr. John',
        ruleSystemId: RuleSystemId.callOfCthulhu7e,
        stats: {'STR': 40, 'CON': 50, 'SIZ': 60, 'DEX': 50, 'APP': 65, 'INT': 75, 'POW': 80, 'EDU': 85, 'HP': 11, 'MAX_HP': 11, 'SAN': 80, 'MP': 16, 'LUCK': 50},
        backstory: 'An antiquarian searching for forbidden books.',
        characterClass: 'Anticuario',
        race: 'Estadounidense',
        createdAt: now,
        updatedAt: now,
      );

      final promptCompact = buildSystemPrompt(
        character: character,
        system: RuleSystem.fromId(RuleSystemId.callOfCthulhu7e),
        languageCode: 'es',
        isCompact: true,
      );

      expect(promptCompact, contains('MECÁNICAS LA LLAMADA DE CTHULHU 7e COMPACTAS:'));
      expect(promptCompact, contains('Tiradas d100 contra Atributos'));
      expect(promptCompact, contains('Locura Temporal'));
      expect(promptCompact, contains('"HP", "SAN", "MP", "LUCK"'));

      final promptStandard = buildSystemPrompt(
        character: character,
        system: RuleSystem.fromId(RuleSystemId.callOfCthulhu7e),
        languageCode: 'es',
        isCompact: false,
      );

      expect(promptStandard, contains('MECÁNICAS DE JUEGO (La Llamada de Cthulhu 7e):'));
      expect(promptStandard, contains('Éxito Normal'));
      expect(promptStandard, contains('Éxito Difícil'));
      expect(promptStandard, contains('Éxito Extremo'));
      expect(promptStandard, contains('Tiradas Forzadas (Pushed Rolls)'));
      expect(promptStandard, contains('LUCK'));
    });
  });
}
