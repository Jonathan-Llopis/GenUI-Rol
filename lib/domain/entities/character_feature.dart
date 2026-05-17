import 'package:equatable/equatable.dart';

class CharacterFeature extends Equatable {
  const CharacterFeature({
    required this.name,
    required this.description,
    this.source = 'Clase',
    this.level = 1,
  });

  final String name;
  final String description;
  final String source;
  final int level;

  @override
  List<Object?> get props => [name, description, source, level];

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'source': source,
    'level': level,
  };

  factory CharacterFeature.fromJson(Map<String, dynamic> json) => CharacterFeature(
    name: json['name'] as String,
    description: json['description'] as String,
    source: json['source'] as String? ?? 'Clase',
    level: json['level'] as int? ?? 1,
  );
}
