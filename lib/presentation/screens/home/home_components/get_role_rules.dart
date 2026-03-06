import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';

class GetRoleRules extends StatelessWidget {
  const GetRoleRules({super.key});

  @override
  Widget build(BuildContext context) {
    final systems = RuleSystem.all;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      itemCount: systems.length,
      itemBuilder: (context, index) {
        final system = systems[index];
        return _SystemCard(system: system);
      },
    );
  }
}

class _SystemCard extends StatelessWidget {
  const _SystemCard({required this.system});
  final RuleSystem system;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => context.goNamed(
          'character-list',
          pathParameters: {'systemId': system.idString},
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              system.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: system.id == RuleSystemId.callOfCthulhu7e
                        ? [const Color(0xFF1a0a2e), const Color(0xFF16213e)]
                        : [const Color(0xFF2d1b4e), const Color(0xFF1a3a5c)],
                  ),
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    system.icon,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    system.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _genreColor(system.genre).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _genreColor(system.genre), width: 1),
                    ),
                    child: Text(
                      system.genre,
                      style: TextStyle(color: _genreColor(system.genre), fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    system.description,
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _genreColor(String genre) => switch (genre) {
    'Horror' => const Color(0xFFFF6B6B),
    'Fantasy' => const Color(0xFFFFD700),
    _ => Colors.blueAccent,
  };
}
