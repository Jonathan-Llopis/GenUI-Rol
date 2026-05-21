import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/item.dart';
import 'package:rol_genui/presentation/blocs/game/game_bloc.dart';
import 'package:rol_genui/presentation/blocs/game/game_event.dart';

class GameInventoryView extends StatelessWidget {
  const GameInventoryView({super.key, required this.character});
  final Character character;

  @override
  Widget build(BuildContext context) {
    final totalWeight = character.inventory.fold<double>(0.0, (sum, item) => sum + item.weight);

    if (character.inventory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text(
              'Tu inventario está vacío',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'El Dungeon Master añadirá objetos a tu mochila a lo largo de la aventura.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.backpack_outlined, color: Theme.of(context).colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Inventario de Aventura',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              Text(
                'Peso Total: ${totalWeight.toStringAsFixed(1)} kg',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: character.inventory.length,
            itemBuilder: (context, index) {
              final item = character.inventory[index];
              final isEquippable = item.type == ItemType.weapon || item.type == ItemType.armor;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: item.isEquipped 
                        ? Colors.green.withValues(alpha: 0.5) 
                        : Theme.of(context).colorScheme.outline.withValues(alpha: 0.08),
                    width: item.isEquipped ? 1.5 : 1.0,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.isEquipped
                          ? Colors.green.withValues(alpha: 0.15)
                          : Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getItemIcon(item.type),
                      color: item.isEquipped ? Colors.green : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                      ),
                      if (item.isEquipped) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'EQUIPADO',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(item.description, style: const TextStyle(fontSize: 12)),
                      if (item.weight > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Peso: ${item.weight} kg',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isEquippable)
                        IconButton(
                          icon: Icon(
                            item.isEquipped ? Icons.shield : Icons.shield_outlined,
                            color: item.isEquipped ? Colors.green : Colors.grey,
                            size: 20,
                          ),
                          tooltip: item.isEquipped ? 'Desequipar' : 'Equipar',
                          onPressed: () {
                            final updatedItem = item.copyWith(isEquipped: !item.isEquipped);
                            final newList = character.inventory.map((i) => i.id == item.id ? updatedItem : i).toList();
                            final updatedChar = character.copyWith(inventory: newList);
                            context.read<GameBloc>().add(UpdateCharacter(updatedChar));
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        tooltip: 'Eliminar objeto',
                        onPressed: () {
                          final newList = character.inventory.where((i) => i.id != item.id).toList();
                          final updatedChar = character.copyWith(inventory: newList);
                          context.read<GameBloc>().add(UpdateCharacter(updatedChar));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getItemIcon(ItemType type) {
    return switch (type) {
      ItemType.weapon => Icons.bolt,
      ItemType.armor => Icons.shield,
      ItemType.consumable => Icons.liquor,
      ItemType.tool => Icons.build,
      ItemType.quest => Icons.auto_awesome,
      ItemType.misc => Icons.category,
    };
  }
}
