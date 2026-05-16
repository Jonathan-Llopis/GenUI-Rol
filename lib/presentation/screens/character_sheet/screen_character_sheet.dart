import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/injection.dart';
import 'package:rol_genui/presentation/blocs/character/character_bloc.dart';

class ScreenCharacterSheet extends StatelessWidget {
  const ScreenCharacterSheet({super.key, required this.character});
  final Character character;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CharacterBloc>(),
      child: _CharacterSheetView(character: character),
    );
  }
}

class _CharacterSheetView extends StatelessWidget {
  const _CharacterSheetView({required this.character});
  final Character character;

  @override
  Widget build(BuildContext context) {
    final system = character.ruleSystem;
    return Scaffold(
      appBar: AppBar(
        title: Text('${system.icon} ${character.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Jugar',
            onPressed: () => context.goNamed(
              'game-session',
              pathParameters: {
                'systemId': system.idString,
                'characterId': character.id,
              },
              extra: character,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _CharacterHeaderCard(character: character, system: system),
            const SizedBox(height: 16),
            // Stats
            _SectionTitle(title: 'Estadísticas'),
            const SizedBox(height: 8),
            _StatsGrid(character: character, system: system),
            const SizedBox(height: 16),
            // Backstory
            if (character.backstory.isNotEmpty) ...[
              _SectionTitle(title: 'Trasfondo'),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(character.backstory),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CharacterHeaderCard extends StatelessWidget {
  const _CharacterHeaderCard({required this.character, required this.system});
  final Character character;
  final RuleSystem system;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                character.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${character.characterClass}${character.race != null ? ' · ${character.race}' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      system.name,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                      ),
                    ),
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

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.character, required this.system});
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
    final derived = system.statSchema.entries
        .where((e) => e.value.type == StatType.derived)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (attributes.isNotEmpty) ...[
          _SubSectionTitle(title: 'Atributos'),
          const SizedBox(height: 8),
          _AttributesRow(entries: attributes, stats: character.stats),
          const SizedBox(height: 12),
        ],
        if (resources.isNotEmpty) ...[
          _SubSectionTitle(title: 'Recursos'),
          const SizedBox(height: 8),
          _ResourcesList(
            entries: resources,
            stats: character.stats,
            system: system,
          ),
          const SizedBox(height: 12),
        ],
        if (derived.isNotEmpty) ...[
          _SubSectionTitle(title: 'Valores derivados'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: derived.map((e) {
              final val = character.stats[e.key] ?? 0;
              return Chip(label: Text('${e.value.label}: $val'));
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _AttributesRow extends StatelessWidget {
  const _AttributesRow({required this.entries, required this.stats});
  final List<MapEntry<String, StatDefinition>> entries;
  final Map<String, int> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: entries.take(6).map((e) {
        final val = stats[e.key] ?? 0;
        final modifier = ((val - 10) / 2).floor();
        return _AttributeBox(
          abbrev: e.key,
          label: e.value.label,
          value: val,
          modifier: modifier,
        );
      }).toList(),
    );
  }
}

class _AttributeBox extends StatelessWidget {
  const _AttributeBox({
    required this.abbrev,
    required this.label,
    required this.value,
    required this.modifier,
  });
  final String abbrev;
  final String label;
  final int value;
  final int modifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            abbrev,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            modifier >= 0 ? '+$modifier' : '$modifier',
            style: TextStyle(
              fontSize: 11,
              color: modifier >= 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourcesList extends StatelessWidget {
  const _ResourcesList({
    required this.entries,
    required this.stats,
    required this.system,
  });
  final List<MapEntry<String, StatDefinition>> entries;
  final Map<String, int> stats;
  final RuleSystem system;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries.map((e) {
        final val = stats[e.key] ?? 0;
        final maxKey = 'MAX_${e.key}';
        final maxVal = stats[maxKey] ?? e.value.max;
        final pct = maxVal > 0 ? val / maxVal : 0.0;
        final color = _resourceColor(e.key, pct);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.value.label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '$val / $maxVal',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRoundedBar(value: pct, color: color),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _resourceColor(String key, double pct) {
    if (key == 'SAN') {
      if (pct < 0.25) return Colors.purple;
      if (pct < 0.5) return Colors.orange;
      return Colors.blue;
    }
    if (pct < 0.25) return Colors.red;
    if (pct < 0.5) return Colors.orange;
    return Colors.green;
  }
}

class ClipRoundedBar extends StatelessWidget {
  const ClipRoundedBar({super.key, required this.value, required this.color});
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        minHeight: 8,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _SubSectionTitle extends StatelessWidget {
  const _SubSectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 1.2,
      ),
    );
  }
}
