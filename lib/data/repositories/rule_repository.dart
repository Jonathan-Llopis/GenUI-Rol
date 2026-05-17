import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:rol_genui/core/logging/app_logger.dart';

class DndRace {
  const DndRace({
    required this.id,
    required this.name,
    required this.description,
    required this.statModifiers,
    required this.size,
    required this.speed,
    required this.languages,
    required this.traits,
    this.subraces = const [],
  });

  final String id;
  final String name;
  final String description;
  final Map<String, int> statModifiers;
  final String size;
  final int speed;
  final List<String> languages;
  final List<Map<String, String>> traits;
  final List<DndRace> subraces;

  factory DndRace.fromJson(Map<String, dynamic> json) {
    return DndRace(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Sin nombre',
      description: json['description']?.toString() ?? '',
      statModifiers: json['statModifiers'] != null
          ? Map<String, int>.from(json['statModifiers'] as Map)
          : const {},
      size: json['size']?.toString() ?? 'Mediano',
      speed: (json['speed'] as num?)?.toInt() ?? 30,
      languages: json['languages'] != null
          ? List<String>.from(json['languages'] as List)
          : const [],
      traits: json['traits'] != null
          ? (json['traits'] as List)
              .map((e) => Map<String, String>.from(e as Map))
              .toList()
          : const [],
      subraces: json['subraces'] != null
          ? (json['subraces'] as List)
              .map((e) => DndRace.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}

class DndClass {
  const DndClass({
    required this.id,
    required this.name,
    required this.description,
    required this.hitDie,
    required this.hpAtLevel1,
    required this.proficiencies,
    required this.features,
  });

  final String id;
  final String name;
  final String description;
  final String hitDie;
  final int hpAtLevel1;
  final Map<String, dynamic> proficiencies;
  final List<Map<String, dynamic>> features;

  factory DndClass.fromJson(Map<String, dynamic> json) {
    return DndClass(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Sin nombre',
      description: json['description']?.toString() ?? '',
      hitDie: json['hitDie']?.toString() ?? '1d8',
      hpAtLevel1: (json['hpAtLevel1'] as num?)?.toInt() ?? 8,
      proficiencies: json['proficiencies'] != null
          ? Map<String, dynamic>.from(json['proficiencies'] as Map)
          : const {},
      features: json['features'] != null
          ? List<Map<String, dynamic>>.from(json['features'] as List)
          : const [],
    );
  }
}

class RuleRepository {
  final _log = getLogger('RuleRepository');
  List<DndRace> _allRaces = [];
  List<DndClass> _classes = [];

  List<DndRace> get races => _allRaces;
  List<DndClass> get classes => _classes;

  Future<void> init() async {
    try {
      final racesJson = await rootBundle.loadString('assets/data/dnd5e_races.json');
      final List<dynamic> racesData = jsonDecode(racesJson);
      final List<DndRace> baseRaces = racesData
          .map((e) => DndRace.fromJson(e as Map<String, dynamic>))
          .toList();

      // Aplanar razas y subrazas para facilitar la búsqueda por nombre en la UI
      _allRaces = [];
      for (final race in baseRaces) {
        _allRaces.add(race);
        _allRaces.addAll(race.subraces);
      }

      final classesJson = await rootBundle.loadString('assets/data/dnd5e_classes.json');
      _classes = (jsonDecode(classesJson) as List)
          .map((e) => DndClass.fromJson(e as Map<String, dynamic>))
          .toList();
      
      _log.info('D&D 5e Rules loaded: ${_allRaces.length} races/subraces, ${_classes.length} classes');
    } catch (e, st) {
      _log.severe('Error loading D&D 5e Rules', e, st);
    }
  }
}
