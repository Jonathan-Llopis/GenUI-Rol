import 'package:rol_genui/domain/entities/rule_system.dart';

class Character {
  const Character({
    required this.id,
    required this.name,
    required this.ruleSystemId,
    required this.stats,
    required this.backstory,
    required this.characterClass,
    this.race,
    this.occupation,
    this.imagePrompt,
    this.inventory = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final RuleSystemId ruleSystemId;
  final Map<String, int> stats;
  final String backstory;
  final String characterClass;
  final String? race;
  final String? occupation;
  final String? imagePrompt;
  final List<String> inventory;
  final DateTime createdAt;
  final DateTime updatedAt;

  RuleSystem get ruleSystem => RuleSystem.fromId(ruleSystemId);

  Character copyWith({
    String? id,
    String? name,
    RuleSystemId? ruleSystemId,
    Map<String, int>? stats,
    String? backstory,
    String? characterClass,
    String? race,
    String? occupation,
    String? imagePrompt,
    List<String>? inventory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      ruleSystemId: ruleSystemId ?? this.ruleSystemId,
      stats: stats ?? this.stats,
      backstory: backstory ?? this.backstory,
      characterClass: characterClass ?? this.characterClass,
      race: race ?? this.race,
      occupation: occupation ?? this.occupation,
      imagePrompt: imagePrompt ?? this.imagePrompt,
      inventory: inventory ?? this.inventory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
