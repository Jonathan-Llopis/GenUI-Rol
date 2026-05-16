import 'package:flutter/material.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';

class GameCharacterView extends StatelessWidget {
  const GameCharacterView({super.key, required this.character});
  final Character character;

  @override
  Widget build(BuildContext context) {
    final system = character.ruleSystem;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CharacterInfoCard(character: character, system: system),
          const SizedBox(height: 16),
          _StatsSection(character: character, system: system),
          const SizedBox(height: 16),
          if (character.backstory.isNotEmpty) ...[
            const Text(
              'Trasfondo',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  character.backstory,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CharacterInfoCard extends StatelessWidget {
  const _CharacterInfoCard({required this.character, required this.system});
  final Character character;
  final RuleSystem system;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(character.name[0].toUpperCase()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${character.characterClass}${character.race != null ? ' · ${character.race}' : ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.character, required this.system});
  final Character character;
  final RuleSystem system;

  @override
  Widget build(BuildContext context) {
    final attributes = system.statSchema.entries
        .where((e) => e.value.type == StatType.attribute)
        .toList();
    final resources = system.statSchema.entries
        .where(
          (e) => e.value.type == StatType.resource && !e.key.startsWith('MAX_'),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (attributes.isNotEmpty) ...[
          const Text(
            'Atributos',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _AttributesGrid(entries: attributes, stats: character.stats),
          const SizedBox(height: 16),
        ],
        if (resources.isNotEmpty) ...[
          const Text(
            'Recursos',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...resources.map(
            (e) => _ResourceRow(
              definition: e.value,
              value: character.stats[e.key] ?? 0,
              maxValue: character.stats['MAX_${e.key}'] ?? e.value.max,
            ),
          ),
        ],
      ],
    );
  }
}

class _AttributesGrid extends StatelessWidget {
  const _AttributesGrid({required this.entries, required this.stats});
  final List<MapEntry<String, StatDefinition>> entries;
  final Map<String, int> stats;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: entries.map((e) {
        final val = stats[e.key] ?? 0;
        return Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                e.key,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                val.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({
    required this.definition,
    required this.value,
    required this.maxValue,
  });
  final StatDefinition definition;
  final int value;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final pct = maxValue > 0 ? value / maxValue : 0.0;
    final color = _getColor(pct);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(definition.label, style: const TextStyle(fontSize: 12)),
              Text(
                '$value / $maxValue',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: pct,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Color _getColor(double pct) {
    if (pct < 0.25) return Colors.red;
    if (pct < 0.5) return Colors.orange;
    return Colors.green;
  }
}
