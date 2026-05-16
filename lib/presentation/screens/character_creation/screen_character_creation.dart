import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/injection.dart';
import 'package:rol_genui/presentation/blocs/character/character_bloc.dart';
import 'package:rol_genui/presentation/blocs/character/character_event.dart';
import 'package:rol_genui/presentation/blocs/character/character_state.dart';
import 'package:uuid/uuid.dart';

class ScreenCharacterCreation extends StatefulWidget {
  const ScreenCharacterCreation({super.key, required this.system});
  final RuleSystem system;

  @override
  State<ScreenCharacterCreation> createState() =>
      _ScreenCharacterCreationState();
}

class _ScreenCharacterCreationState extends State<ScreenCharacterCreation> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _backstoryCtrl = TextEditingController();

  String? _selectedClass;
  String? _selectedRace;
  late Map<String, int> _stats;

  @override
  void initState() {
    super.initState();
    _stats = _defaultStats();
  }

  Map<String, int> _defaultStats() {
    final schema = widget.system.statSchema;
    return {
      for (final e in schema.entries)
        e.key: _defaultValue(e.key, e.value, widget.system.id),
    };
  }

  int _defaultValue(String key, StatDefinition def, RuleSystemId systemId) {
    if (systemId == RuleSystemId.callOfCthulhu7e) {
      return switch (key) {
        'HP' || 'MAX_HP' => 10,
        'SAN' || 'MAX_SAN' => 60,
        'MP' => 10,
        'LUCK' => 50,
        _ => 50,
      };
    } else {
      return switch (def.type) {
        StatType.attribute => 10,
        StatType.resource when key == 'HP' || key == 'MAX_HP' => 10,
        StatType.resource when key == 'XP' => 0,
        StatType.resource when key == 'HERO_POINTS' => 1,
        StatType.derived when key == 'LEVEL' => 1,
        StatType.derived when key == 'AC' => 10,
        _ => 0,
      };
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _backstoryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CharacterBloc>(),
      child: BlocConsumer<CharacterBloc, CharacterState>(
        listener: (context, state) {
          if (state is CharacterOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('¡Personaje creado!')));
            context.pop();
          }
          if (state is CharacterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Crear personaje · ${widget.system.icon}'),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionHeader(title: 'Información básica'),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del personaje *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? 'El nombre es obligatorio'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  // ── Selector de clase / ocupación ──────────────────────────
                  DropdownButtonFormField<String>(
                    initialValue: _selectedClass,
                    decoration: InputDecoration(
                      labelText: '${widget.system.classLabel} *',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.work),
                    ),
                    items: widget.system.classes
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedClass = v),
                    validator: (v) => v == null || v.isEmpty
                        ? '${widget.system.classLabel} es obligatoria'
                        : null,
                    isExpanded: true,
                    menuMaxHeight: 320,
                  ),
                  const SizedBox(height: 12),
                  // ── Selector de raza / ancestría (no aplica en CoC) ────────
                  if (widget.system.hasRaces) ...[
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRace,
                      decoration: InputDecoration(
                        labelText: widget.system.raceLabel,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.face),
                      ),
                      items: widget.system.races
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedRace = v),
                      isExpanded: true,
                      menuMaxHeight: 320,
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextFormField(
                    controller: _backstoryCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Trasfondo / Historia',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.book),
                    ),
                    maxLines: 4,
                    maxLength: 500,
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Estadísticas iniciales'),
                  const SizedBox(height: 12),
                  _StatsEditor(
                    system: widget.system,
                    stats: _stats,
                    onChanged: (key, value) =>
                        setState(() => _stats[key] = value),
                  ),
                  const SizedBox(height: 32),
                  if (state is CharacterLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    FilledButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Crear personaje'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      onPressed: () => _onSubmit(context),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() != true) return;
    final now = DateTime.now();
    final character = Character(
      id: const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      ruleSystemId: widget.system.id,
      stats: Map.from(_stats),
      backstory: _backstoryCtrl.text.trim(),
      characterClass: _selectedClass ?? '',
      race: _selectedRace,
      createdAt: now,
      updatedAt: now,
    );
    context.read<CharacterBloc>().add(CreateCharacter(character));
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}

class _StatsEditor extends StatelessWidget {
  const _StatsEditor({
    required this.system,
    required this.stats,
    required this.onChanged,
  });
  final RuleSystem system;
  final Map<String, int> stats;
  final void Function(String key, int value) onChanged;

  @override
  Widget build(BuildContext context) {
    final entries = system.statSchema.entries.toList();
    return Column(
      children: entries.map((e) {
        final def = e.value;
        final value = stats[e.key] ?? def.min;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  '${def.label} (${e.key})',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Slider(
                  value: value.toDouble(),
                  min: def.min.toDouble(),
                  max: def.max.toDouble(),
                  divisions: (def.max - def.min).clamp(1, 100),
                  label: value.toString(),
                  onChanged: (v) => onChanged(e.key, v.round()),
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
