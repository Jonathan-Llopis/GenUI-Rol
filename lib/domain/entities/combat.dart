import 'package:equatable/equatable.dart';

class CombatEnemy extends Equatable {
  const CombatEnemy({
    required this.name,
    required this.hp,
    required this.ac,
    this.maxHp,
  });
  final String name;
  final int hp;
  final int ac;
  final int? maxHp;

  @override
  List<Object?> get props => [name, hp, ac, maxHp];

  factory CombatEnemy.fromJson(Map<String, dynamic> json) {
    final hpVal = json['hp'] as int;
    return CombatEnemy(
      name: json['name'] as String,
      hp: hpVal,
      ac: json['ac'] as int,
      maxHp: json['max_hp'] as int? ?? hpVal,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'hp': hp,
        'ac': ac,
        'max_hp': maxHp ?? hp,
      };
}

class CombatState extends Equatable {
  const CombatState({required this.isActive, this.enemies = const []});
  final bool isActive;
  final List<CombatEnemy> enemies;

  @override
  List<Object?> get props => [isActive, enemies];

  factory CombatState.fromJson(Map<String, dynamic> json) => CombatState(
    isActive: json['active'] as bool? ?? false,
    enemies:
        (json['enemies'] as List<dynamic>?)
            ?.map((e) => CombatEnemy.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'active': isActive,
    'enemies': enemies.map((e) => e.toJson()).toList(),
  };
}
