import 'package:rol_genui/domain/entities/rule_system.dart';

class GameSession {
  const GameSession({
    required this.id,
    required this.characterId,
    required this.ruleSystemId,
    required this.title,
    required this.summary,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  final String id;
  final String characterId;
  final RuleSystemId ruleSystemId;
  final String title;
  final String summary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  GameSession copyWith({
    String? id,
    String? characterId,
    RuleSystemId? ruleSystemId,
    String? title,
    String? summary,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return GameSession(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      ruleSystemId: ruleSystemId ?? this.ruleSystemId,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
