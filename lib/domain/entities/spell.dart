import 'package:equatable/equatable.dart';

class Spell extends Equatable {
  const Spell({
    required this.name,
    required this.level,
    required this.school,
    required this.castingTime,
    required this.range,
    required this.components,
    required this.duration,
    required this.description,
  });

  final String name;
  final int level;
  final String school;
  final String castingTime;
  final String range;
  final String components;
  final String duration;
  final String description;

  @override
  List<Object?> get props => [name, level, school, castingTime, range, components, duration, description];

  Map<String, dynamic> toJson() => {
    'name': name,
    'level': level,
    'school': school,
    'castingTime': castingTime,
    'range': range,
    'components': components,
    'duration': duration,
    'description': description,
  };

  factory Spell.fromJson(Map<String, dynamic> json) => Spell(
    name: json['name'] as String,
    level: json['level'] as int,
    school: json['school'] as String,
    castingTime: json['castingTime'] as String,
    range: json['range'] as String,
    components: json['components'] as String,
    duration: json['duration'] as String,
    description: json['description'] as String,
  );
}
