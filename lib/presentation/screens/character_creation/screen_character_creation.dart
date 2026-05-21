import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rol_genui/data/repositories/rule_repository.dart';
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
  State<ScreenCharacterCreation> createState() => _ScreenCharacterCreationState();
}

class _ScreenCharacterCreationState extends State<ScreenCharacterCreation> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Step 1: Identidad
  final _nameCtrl = TextEditingController();
  final _backstoryCtrl = TextEditingController();

  // Step 2: Orígenes
  String? _selectedClass;
  String? _selectedRace;
  DndRace? _dndRace;
  DndClass? _dndClass;

  // Step 3: Atributos
  late Map<String, int> _stats;
  late int _availablePoints;

  @override
  void initState() {
    super.initState();
    _availablePoints = switch (widget.system.id) {
      RuleSystemId.dnd5e => 27,
      RuleSystemId.pathfinder2e => 9,
      RuleSystemId.callOfCthulhu7e => 460,
    };
    _stats = _initialStats();
    _recalculatePoints();
  }

  Map<String, int> _initialStats() {
    final schema = widget.system.statSchema;
    final Map<String, int> base = {};
    for (final e in schema.entries) {
      if (e.value.type == StatType.attribute) {
        base[e.key] = switch (widget.system.id) {
          RuleSystemId.dnd5e => 8,
          RuleSystemId.pathfinder2e => 10,
          RuleSystemId.callOfCthulhu7e => 15,
        };
      } else {
        base[e.key] = _defaultValue(e.key, e.value);
      }
    }
    return base;
  }

  int _defaultValue(String key, StatDefinition def) {
    return switch (def.type) {
      StatType.resource when key == 'HP' || key == 'MAX_HP' => 10,
      StatType.derived when key == 'LEVEL' => 1,
      StatType.derived when key == 'AC' => 10,
      StatType.resource when key == 'SAN' || key == 'MAX_SAN' => 50,
      StatType.resource when key == 'MP' => 10,
      StatType.resource when key == 'LUCK' => 50,
      _ => 0,
    };
  }

  void _onRaceSelected(String? raceName) {
    setState(() {
      _selectedRace = raceName;
      if (widget.system.id == RuleSystemId.dnd5e && raceName != null) {
        final rules = sl<RuleRepository>();
        try {
          _dndRace = rules.races.firstWhere((r) => r.name == raceName);
          _recalculatePoints(); // Reset points when changing race
        } catch (_) {
          _dndRace = null;
        }
      } else {
        _recalculatePoints();
      }
    });
  }

  void _onClassSelected(String? className) {
    setState(() {
      _selectedClass = className;
      if (widget.system.id == RuleSystemId.dnd5e && className != null) {
        final rules = sl<RuleRepository>();
        try {
          _dndClass = rules.classes.firstWhere((c) => c.name == className);
          _updateHp();
        } catch (_) {
          _dndClass = null;
        }
      } else {
        _updateHp();
      }
    });
  }

  int _pf2eAncestryHp(String? race) {
    if (race == null) return 8;
    return switch (race.toLowerCase()) {
      'elfo' || 'goblin' || 'mediano' => 6,
      'enano' => 10,
      'humano' || 'gnomo' || 'hobgoblin' || 'leshy' || 'orco' || 'catfolk' || 'kobold' || 'ratfolk' || 'tengu' || 'sprites' || 'fetchling' || 'fleshwarp' || 'grippli' => 8,
      _ => 8,
    };
  }

  int _pf2eClassHp(String? className) {
    if (className == null) return 8;
    return switch (className.toLowerCase()) {
      'bárbaro' => 12,
      'campeón' || 'guerrero' || 'monje' || 'explorador' => 10,
      'mago' || 'hechicero' || 'bruja' || 'psíquico' || 'nigromante' || 'oráculo' => 6,
      _ => 8,
    };
  }

  void _updateHp() {
    if (widget.system.id == RuleSystemId.dnd5e) {
      if (_dndClass != null) {
        final conMod = ((_stats['CON']! + (_dndRace?.statModifiers['CON'] ?? 0) - 10) ~/ 2);
        _stats['HP'] = _dndClass!.hpAtLevel1 + conMod;
        _stats['MAX_HP'] = _stats['HP']!;
      }
    } else if (widget.system.id == RuleSystemId.pathfinder2e) {
      final ancestryHp = _pf2eAncestryHp(_selectedRace);
      final classHp = _pf2eClassHp(_selectedClass);
      final conMod = (_stats['CON']! - 10) ~/ 2;
      _stats['HP'] = ancestryHp + classHp + conMod;
      _stats['MAX_HP'] = _stats['HP']!;
    } else if (widget.system.id == RuleSystemId.callOfCthulhu7e) {
      final con = _stats['CON'] ?? 15;
      final siz = _stats['SIZ'] ?? 15;
      _stats['HP'] = (con + siz) ~/ 10;
      _stats['MAX_HP'] = _stats['HP']!;
    }
  }

  void _recalculatePoints() {
    int spent = 0;
    _stats.forEach((key, val) {
      if (widget.system.statSchema[key]?.type == StatType.attribute) {
        spent += switch (widget.system.id) {
          RuleSystemId.dnd5e => _pointCost(val),
          RuleSystemId.pathfinder2e => (val - 10) ~/ 2,
          RuleSystemId.callOfCthulhu7e => val - 15,
        };
      }
    });
    setState(() {
      _availablePoints = (switch (widget.system.id) {
        RuleSystemId.dnd5e => 27,
        RuleSystemId.pathfinder2e => 9,
        RuleSystemId.callOfCthulhu7e => 460,
      }) - spent;
    });
    _updateHp();
    _updateAc();
    _updateCoCResources();
  }

  int _pointCost(int score) {
    if (score <= 13) return score - 8;
    if (score == 14) return 7;
    if (score == 15) return 9;
    return 0;
  }

  void _updateAc() {
    if (widget.system.id == RuleSystemId.dnd5e) {
      final dexMod = ((_stats['DEX']! + (_dndRace?.statModifiers['DEX'] ?? 0) - 10) ~/ 2);
      _stats['AC'] = 10 + dexMod;
      if (_dndClass?.id == 'barbaro') {
        final conMod = ((_stats['CON']! + (_dndRace?.statModifiers['CON'] ?? 0) - 10) ~/ 2);
        _stats['AC'] = 10 + dexMod + conMod;
      }
    } else if (widget.system.id == RuleSystemId.pathfinder2e) {
      final dexMod = (_stats['DEX']! - 10) ~/ 2;
      _stats['AC'] = 12 + dexMod;
    }
  }

  void _updateCoCResources() {
    if (widget.system.id == RuleSystemId.callOfCthulhu7e) {
      final pow = _stats['POW'] ?? 15;
      _stats['SAN'] = pow;
      _stats['MAX_SAN'] = 99;
      _stats['MP'] = pow ~/ 5;
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
            context.pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Crear Héroe · Step ${_currentStep + 1}/4')),
            body: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 3) {
                  if (_currentStep == 0 && !_formKey.currentState!.validate()) return;
                  setState(() => _currentStep++);
                } else {
                  _onSubmit(context);
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) setState(() => _currentStep--);
              },
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: details.onStepContinue,
                          child: Text(_currentStep == 3 ? 'Crear Personaje' : 'Siguiente'),
                        ),
                      ),
                      if (_currentStep > 0) ...[
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Atrás'),
                        ),
                      ],
                    ],
                  ),
                );
              },
              steps: [
                Step(
                  title: const Icon(Icons.badge),
                  isActive: _currentStep >= 0,
                  content: _StepIdentity(),
                ),
                Step(
                  title: const Icon(Icons.auto_stories),
                  isActive: _currentStep >= 1,
                  content: _StepOrigins(),
                ),
                Step(
                  title: const Icon(Icons.fitness_center),
                  isActive: _currentStep >= 2,
                  content: _StepAttributes(),
                ),
                Step(
                  title: const Icon(Icons.fact_check),
                  isActive: _currentStep >= 3,
                  content: _StepReview(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _StepIdentity() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Nombre del Aventurero', border: OutlineInputBorder()),
            validator: (v) => v == null || v.isEmpty ? 'Ponle un nombre a tu héroe' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _backstoryCtrl,
            decoration: const InputDecoration(labelText: 'Breve historia o motivación', border: OutlineInputBorder()),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _StepOrigins() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedRace,
          decoration: InputDecoration(
            labelText: widget.system.id == RuleSystemId.callOfCthulhu7e
                ? 'Nacionalidad / Origen' 
                : widget.system.raceLabel,
            border: const OutlineInputBorder()
          ),
          items: widget.system.id == RuleSystemId.callOfCthulhu7e 
              ? ['Estadounidense', 'Británico', 'Francés', 'Alemán', 'Español', 'Mexicano', 'Japonés', 'Otro'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList()
              : widget.system.races.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
          onChanged: _onRaceSelected,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedClass,
          decoration: InputDecoration(labelText: widget.system.classLabel, border: const OutlineInputBorder()),
          items: widget.system.classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: _onClassSelected,
        ),
        if (_dndRace != null || _dndClass != null) ...[
          const SizedBox(height: 16),
          _SelectionInfo(race: _dndRace, dndClass: _dndClass),
        ],
      ],
    );
  }

  Widget _StepAttributes() {
    final attrs = widget.system.statSchema.entries.where((e) => e.value.type == StatType.attribute).toList();
    final pointLabel = switch (widget.system.id) {
      RuleSystemId.dnd5e => 'Puntos Disponibles (Point Buy):',
      RuleSystemId.pathfinder2e => 'Incrementos (Boosts) Disponibles:',
      RuleSystemId.callOfCthulhu7e => 'Puntos Disponibles (Pool):',
    };
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(pointLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('$_availablePoints', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _availablePoints < 0 ? Colors.red : null)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...attrs.map((e) {
          final val = _stats[e.key]!;
          final racialMod = _dndRace?.statModifiers[e.key] ?? 0;
          
          final bool canRemove = switch (widget.system.id) {
            RuleSystemId.dnd5e => val > 8,
            RuleSystemId.pathfinder2e => val > 10,
            RuleSystemId.callOfCthulhu7e => val > 15,
          };
          
          final bool canAdd = switch (widget.system.id) {
            RuleSystemId.dnd5e => val < 15 && _availablePoints >= (val >= 13 ? 2 : 1),
            RuleSystemId.pathfinder2e => val < 18 && _availablePoints >= 1,
            RuleSystemId.callOfCthulhu7e => val < 90 && _availablePoints >= 5,
          };
          
          final int step = switch (widget.system.id) {
            RuleSystemId.dnd5e => 1,
            RuleSystemId.pathfinder2e => 2,
            RuleSystemId.callOfCthulhu7e => 5,
          };

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(width: 100, child: Text(e.value.label)),
                IconButton(
                  onPressed: canRemove ? () => setState(() { _stats[e.key] = val - step; _recalculatePoints(); }) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$val', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: canAdd ? () => setState(() { _stats[e.key] = val + step; _recalculatePoints(); }) : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
                if (widget.system.id == RuleSystemId.dnd5e && racialMod != 0) 
                  Text('+$racialMod racial', style: const TextStyle(fontSize: 10, color: Colors.green)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _StepReview() {
    final finalStats = Map<String, int>.from(_stats);
    if (_dndRace != null) {
      _dndRace!.statModifiers.forEach((k, v) {
        if (finalStats.containsKey(k)) finalStats[k] = finalStats[k]! + v;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_nameCtrl.text, style: Theme.of(context).textTheme.headlineSmall),
        Text('${_selectedRace ?? ""} · ${_selectedClass ?? ""}', style: const TextStyle(fontStyle: FontStyle.italic)),
        const Divider(),
        const Text('Estadísticas Finales:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: finalStats.entries.where((e) => widget.system.statSchema[e.key]?.type == StatType.attribute).map((e) {
            if (widget.system.id == RuleSystemId.callOfCthulhu7e) {
              final half = e.value ~/ 2;
              final fifth = e.value ~/ 5;
              return Chip(label: Text('${e.key}: ${e.value} ($half/$fifth)'));
            } else {
              final mod = (e.value - 10) ~/ 2;
              return Chip(label: Text('${e.key}: ${e.value} (${mod >= 0 ? "+" : ""}$mod)'));
            }
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (widget.system.id == RuleSystemId.callOfCthulhu7e) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DerivedStat(label: 'Puntos de Vida', value: '${_stats['HP']}', icon: Icons.favorite),
              _DerivedStat(label: 'Cordura', value: '${_stats['SAN']}', icon: Icons.psychology),
              _DerivedStat(label: 'Puntos de Magia', value: '${_stats['MP']}', icon: Icons.auto_awesome),
              _DerivedStat(label: 'Suerte', value: '${_stats['LUCK']}', icon: Icons.casino),
            ],
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DerivedStat(label: 'Puntos de Vida', value: '${_stats['HP']}', icon: Icons.favorite),
              _DerivedStat(label: 'C. Armadura', value: '${_stats['AC']}', icon: Icons.shield),
            ],
          ),
        ],
      ],
    );
  }

  void _onSubmit(BuildContext context) {
    final now = DateTime.now();
    final finalStats = Map<String, int>.from(_stats);
    if (_dndRace != null) {
      _dndRace!.statModifiers.forEach((k, v) {
        if (finalStats.containsKey(k)) finalStats[k] = finalStats[k]! + v;
      });
    }

    final character = Character(
      id: const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      ruleSystemId: widget.system.id,
      stats: finalStats,
      backstory: _backstoryCtrl.text.trim(),
      characterClass: _selectedClass ?? '',
      race: _selectedRace,
      createdAt: now,
      updatedAt: now,
    );
    context.read<CharacterBloc>().add(CreateCharacter(character));
  }
}

class _DerivedStat extends StatelessWidget {
  const _DerivedStat({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class _SelectionInfo extends StatelessWidget {
  const _SelectionInfo({this.race, this.dndClass});
  final DndRace? race;
  final DndClass? dndClass;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (race != null) ...[
              Text('Beneficios de ${race!.name}:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(race!.traits.isEmpty ? 'Ninguno' : race!.traits.map((t) => t['name']).join(', '), style: const TextStyle(fontSize: 11)),
            ],
            if (dndClass != null) ...[
              if (race != null) const SizedBox(height: 8),
              Text('Atributos de ${dndClass!.name}:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text('Dado de vida: ${dndClass!.hitDie}', style: const TextStyle(fontSize: 11)),
            ],
          ],
        ),
      ),
    );
  }
}
