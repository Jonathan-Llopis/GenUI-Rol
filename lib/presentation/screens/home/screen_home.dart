import 'package:flutter/material.dart';
import 'package:rol_genui/presentation/functions/implemented_rol.dart';
import 'package:rol_genui/presentation/screens/home/home_components/get_role_rules.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final Map<String, String> implementedRolRules = getImplementedRolRules();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: GetRoleRules(implementedRolRules: implementedRolRules),
          ),
        );
      },
    );
  }
}
