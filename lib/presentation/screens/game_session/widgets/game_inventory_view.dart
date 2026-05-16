import 'package:flutter/material.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/item.dart';

class GameInventoryView extends StatelessWidget {
  const GameInventoryView({super.key, required this.character});
  final Character character;

  @override
  Widget build(BuildContext context) {
    if (character.inventory.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tu inventario está vacío',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: character.inventory.length,
      itemBuilder: (context, index) {
        final item = character.inventory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getItemIcon(item.type),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
            trailing: item.isEquipped
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.5)),
                    ),
                    child: const Text(
                      'EQUIPADO',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
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
