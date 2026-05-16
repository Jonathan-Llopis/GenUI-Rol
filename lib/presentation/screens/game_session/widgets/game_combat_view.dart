import 'package:flutter/material.dart';
import 'package:rol_genui/domain/entities/combat.dart';

class GameCombatView extends StatelessWidget {
  const GameCombatView({super.key, this.combatState});
  final CombatState? combatState;

  @override
  Widget build(BuildContext context) {
    if (combatState == null || !combatState!.isActive) {
      return const _NoCombatActiveView();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.red.withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 12),
              Text(
                '¡EN COMBATE!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: combatState!.enemies.length,
            itemBuilder: (context, index) {
              final enemy = combatState!.enemies[index];
              return _EnemyCombatCard(enemy: enemy);
            },
          ),
        ),
      ],
    );
  }
}

class _NoCombatActiveView extends StatelessWidget {
  const _NoCombatActiveView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No hay combates activos', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'El tracker de combate aparecerá aquí cuando el Dungeon Master inicie un encuentro.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _EnemyCombatCard extends StatelessWidget {
  const _EnemyCombatCard({required this.enemy});
  final CombatEnemy enemy;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.red),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enemy.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'CA: ${enemy.ac}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${enemy.hp} HP',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 1.0, // AI will update HP later
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
