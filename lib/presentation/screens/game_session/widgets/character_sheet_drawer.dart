import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/presentation/blocs/game/game_bloc.dart';
import 'package:rol_genui/presentation/blocs/game/game_event.dart';
import 'package:rol_genui/presentation/blocs/game/game_state.dart';

class CharacterSheetDrawer extends StatefulWidget {
  const CharacterSheetDrawer({super.key, required this.character});
  final Character character;

  @override
  State<CharacterSheetDrawer> createState() => _CharacterSheetDrawerState();
}

class _CharacterSheetDrawerState extends State<CharacterSheetDrawer> {
  // Controla qué secciones están expandidas
  bool _statsExpanded = true;
  bool _resourcesExpanded = true;
  bool _derivedExpanded = true;
  bool _inventoryExpanded = true;
  bool _backstoryExpanded = false;

  // Campo de texto para añadir objetos al inventario
  final _itemController = TextEditingController();

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final system = character.ruleSystem;
    final cs = Theme.of(context).colorScheme;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      child: Column(
        children: [
          _Header(character: character, system: system),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              children: [
                _statsSection(character, system, cs),
                _resourcesSection(character, system, cs),
                _derivedSection(character, system, cs),
                _inventorySection(character, cs),
                _backstorySection(character, cs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Atributos principales ──────────────────────────────────────────────────

  Widget _statsSection(Character c, RuleSystem system, ColorScheme cs) {
    final attrs = system.statSchema.entries
        .where((e) => e.value.type == StatType.attribute)
        .toList();
    if (attrs.isEmpty) return const SizedBox.shrink();

    return _Section(
      title: 'Atributos',
      icon: Icons.fitness_center,
      color: cs.primary,
      expanded: _statsExpanded,
      onToggle: () => setState(() => _statsExpanded = !_statsExpanded),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: attrs.map((e) {
          final value = c.stats[e.key] ?? 0;
          return _StatChip(
            label: e.value.label,
            shortKey: e.key,
            value: value,
            color: cs.primaryContainer,
            textColor: cs.onPrimaryContainer,
          );
        }).toList(),
      ),
    );
  }

  // ── Recursos (HP, SAN, MP…) ───────────────────────────────────────────────

  Widget _resourcesSection(Character c, RuleSystem system, ColorScheme cs) {
    final resources = system.statSchema.entries
        .where((e) => e.value.type == StatType.resource)
        .toList();
    if (resources.isEmpty) return const SizedBox.shrink();

    // Separar pares current/max (HP/MAX_HP, SAN/MAX_SAN…)
    final maxKeys = resources.map((e) => e.key).where((k) => k.startsWith('MAX_')).toSet();
    final currentKeys = resources.map((e) => e.key).where((k) => !k.startsWith('MAX_')).toList();

    return _Section(
      title: 'Recursos',
      icon: Icons.favorite,
      color: Colors.red.shade700,
      expanded: _resourcesExpanded,
      onToggle: () => setState(() => _resourcesExpanded = !_resourcesExpanded),
      child: Column(
        children: currentKeys.map((key) {
          final maxKey = 'MAX_$key';
          final current = c.stats[key] ?? 0;
          final max = maxKeys.contains(maxKey) ? (c.stats[maxKey] ?? 1) : null;
          final label = system.statSchema[key]?.label ?? key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ResourceBar(
              label: label,
              current: current,
              max: max,
              color: _resourceColor(key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _resourceColor(String key) {
    if (key == 'HP') return Colors.green.shade700;
    if (key == 'SAN') return Colors.purple.shade700;
    if (key == 'MP') return Colors.blue.shade700;
    if (key == 'LUCK') return Colors.orange.shade700;
    if (key == 'XP') return Colors.teal.shade700;
    return Colors.grey.shade600;
  }

  // ── Estadísticas derivadas ─────────────────────────────────────────────────

  Widget _derivedSection(Character c, RuleSystem system, ColorScheme cs) {
    final derived = system.statSchema.entries
        .where((e) => e.value.type == StatType.derived)
        .toList();
    if (derived.isEmpty) return const SizedBox.shrink();

    return _Section(
      title: 'Otros',
      icon: Icons.auto_graph,
      color: cs.tertiary,
      expanded: _derivedExpanded,
      onToggle: () => setState(() => _derivedExpanded = !_derivedExpanded),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: derived.map((e) {
          final value = c.stats[e.key] ?? 0;
          return _StatChip(
            label: e.value.label,
            shortKey: e.key,
            value: value,
            color: cs.tertiaryContainer,
            textColor: cs.onTertiaryContainer,
          );
        }).toList(),
      ),
    );
  }

  // ── Inventario ─────────────────────────────────────────────────────────────

  Widget _inventorySection(Character c, ColorScheme cs) {
    return _Section(
      title: 'Inventario',
      icon: Icons.backpack,
      color: Colors.amber.shade700,
      expanded: _inventoryExpanded,
      onToggle: () => setState(() => _inventoryExpanded = !_inventoryExpanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (c.inventory.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Sin objetos',
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5), fontSize: 13),
              ),
            )
          else
            ...c.inventory.asMap().entries.map((entry) => _InventoryItem(
                  item: entry.value,
                  onRemove: () => _removeInventoryItem(c, entry.key),
                )),
          _AddItemField(
            controller: _itemController,
            onAdd: () => _addInventoryItem(c),
          ),
        ],
      ),
    );
  }

  void _addInventoryItem(Character c) {
    final text = _itemController.text.trim();
    if (text.isEmpty) return;
    final updated = c.copyWith(inventory: [...c.inventory, text]);
    context.read<GameBloc>().add(UpdateCharacter(updated));
    _itemController.clear();
  }

  void _removeInventoryItem(Character c, int index) {
    final newList = List<String>.from(c.inventory)..removeAt(index);
    final updated = c.copyWith(inventory: newList);
    context.read<GameBloc>().add(UpdateCharacter(updated));
  }

  // ── Trasfondo ──────────────────────────────────────────────────────────────

  Widget _backstorySection(Character c, ColorScheme cs) {
    return _Section(
      title: 'Trasfondo',
      icon: Icons.menu_book,
      color: cs.secondary,
      expanded: _backstoryExpanded,
      onToggle: () => setState(() => _backstoryExpanded = !_backstoryExpanded),
      child: Text(
        c.backstory.isEmpty ? 'Sin trasfondo definido.' : c.backstory,
        style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.85), height: 1.5),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.character, required this.system});
  final Character character;
  final RuleSystem system;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final subtitle = [
      character.characterClass,
      if (character.race != null && character.race!.isNotEmpty) character.race!,
      if (character.occupation != null && character.occupation!.isNotEmpty) character.occupation!,
    ].join(' • ');

    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        // Usa el personaje actualizado del estado si está disponible
        final char = state is GameTurn ? state.character : character;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.primaryContainer, cs.secondaryContainer],
            ),
          ),
          padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: cs.primary.withValues(alpha: 0.2),
                    child: Text(
                      system.icon,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          char.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimaryContainer,
                          ),
                        ),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onPrimaryContainer.withValues(alpha: 0.7),
                            ),
                          ),
                        Text(
                          system.name,
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.onPrimaryContainer.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Section wrapper ────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.color,
    required this.expanded,
    required this.onToggle,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color color;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: color.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: child,
          ),
        Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
      ],
    );
  }
}

// ── Stat chip ─────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.shortKey,
    required this.value,
    required this.color,
    required this.textColor,
  });

  final String label;
  final String shortKey;
  final int value;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            shortKey,
            style: TextStyle(
              fontSize: 10,
              color: textColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Resource bar ─────────────────────────────────────────────────────────────

class _ResourceBar extends StatelessWidget {
  const _ResourceBar({
    required this.label,
    required this.current,
    this.max,
    required this.color,
  });

  final String label;
  final int current;
  final int? max;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasBar = max != null && max! > 0;
    final ratio = hasBar ? (current / max!).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.7))),
            Text(
              max != null ? '$current / $max' : '$current',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
        if (hasBar) ...[
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 7,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Inventory item ────────────────────────────────────────────────────────────

class _InventoryItem extends StatelessWidget {
  const _InventoryItem({required this.item, required this.onRemove});
  final String item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.circle, size: 6, color: cs.onSurface.withValues(alpha: 0.4)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(item, style: const TextStyle(fontSize: 13)),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.remove_circle_outline,
                size: 18, color: cs.error.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

// ── Add item field ────────────────────────────────────────────────────────────

class _AddItemField extends StatelessWidget {
  const _AddItemField({required this.controller, required this.onAdd});
  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Añadir objeto...',
              hintStyle: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.4)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.5)),
              ),
            ),
            onSubmitted: (_) => onAdd(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onAdd,
          icon: Icon(Icons.add_circle, color: cs.primary),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
      ],
    );
  }
}
