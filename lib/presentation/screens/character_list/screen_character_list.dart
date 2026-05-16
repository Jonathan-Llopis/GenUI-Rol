import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/injection.dart';
import 'package:rol_genui/presentation/blocs/character/character_bloc.dart';
import 'package:rol_genui/presentation/blocs/character/character_event.dart';
import 'package:rol_genui/presentation/blocs/character/character_state.dart';

class ScreenCharacterList extends StatefulWidget {
  const ScreenCharacterList({super.key, required this.system});
  final RuleSystem system;

  @override
  State<ScreenCharacterList> createState() => _ScreenCharacterListState();
}

class _ScreenCharacterListState extends State<ScreenCharacterList> {
  late final CharacterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<CharacterBloc>()..add(LoadCharactersBySystem(widget.system.id));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _goToCreate() {
    context
        .pushNamed(
          'character-create',
          pathParameters: {'systemId': widget.system.idString},
        )
        .then((_) {
          // Recargar lista al volver desde la pantalla de creación
          if (mounted) {
            _bloc.add(LoadCharactersBySystem(widget.system.id));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: _ScreenCharacterListView(
        system: widget.system,
        onCreateTap: _goToCreate,
      ),
    );
  }
}

class _ScreenCharacterListView extends StatelessWidget {
  const _ScreenCharacterListView({
    required this.system,
    required this.onCreateTap,
  });
  final RuleSystem system;
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${system.icon} ${system.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear personaje',
            onPressed: onCreateTap,
          ),
        ],
      ),
      body: BlocConsumer<CharacterBloc, CharacterState>(
        listener: (context, state) {
          if (state is CharacterOperationSuccess && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
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
          if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final characters = switch (state) {
            CharactersLoaded s => s.characters,
            CharacterOperationSuccess s => s.characters,
            _ => const [],
          };

          if (characters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(system.icon, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes personajes en ${system.name}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text('Crear personaje'),
                    onPressed: onCreateTap,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(
                      character.name.isNotEmpty
                          ? character.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    character.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${character.characterClass}${character.race != null ? ' · ${character.race}' : ''}',
                      ),
                      const SizedBox(height: 4),
                      _buildStatChips(context, character),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'sheet') {
                        context.goNamed(
                          'character-sheet',
                          pathParameters: {
                            'systemId': system.idString,
                            'characterId': character.id,
                          },
                          extra: character,
                        );
                      } else if (value == 'delete') {
                        _confirmDelete(context, character.id, character.name);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'sheet',
                        child: Text('Ver ficha'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                  onTap: () => context.goNamed(
                    'game-session',
                    pathParameters: {
                      'systemId': system.idString,
                      'characterId': character.id,
                    },
                    extra: character,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onCreateTap,
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo personaje'),
      ),
    );
  }

  Widget _buildStatChips(BuildContext context, character) {
    final keyStats = system.statSchema.entries
        .where((e) => e.value.type == StatType.resource)
        .take(3)
        .toList();
    return Wrap(
      spacing: 4,
      children: keyStats.map((e) {
        final val = character.stats[e.key] ?? 0;
        return Chip(
          label: Text('${e.value.label}: $val'),
          padding: EdgeInsets.zero,
          labelStyle: const TextStyle(fontSize: 10),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  void _confirmDelete(BuildContext context, String id, String name) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar personaje'),
        content: Text('¿Eliminar a "$name"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<CharacterBloc>().add(DeleteCharacter(id));
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
