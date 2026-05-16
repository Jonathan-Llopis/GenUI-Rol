import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rol_genui/presentation/screens/home/home_components/get_role_rules.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Column(
                children: [
                  Text(
                    '⚔️ Rol GenUI',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Elige tu sistema de rol y comienza la aventura',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push('/home/settings'),
                tooltip: 'Ajustes de IA',
              ),
            ),
          ],
        ),
        const Expanded(child: GetRoleRules()),
      ],
    );
  }
}
