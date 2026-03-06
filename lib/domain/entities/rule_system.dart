enum RuleSystemId { dnd5e, pathfinder2e, callOfCthulhu7e }

class RuleSystem {
  const RuleSystem({
    required this.id,
    required this.name,
    required this.description,
    required this.genre,
    required this.imageAsset,
    required this.statSchema,
    required this.icon,
    required this.classes,
    this.races = const [],
    this.classLabel = 'Clase',
    this.raceLabel = 'Raza',
  });

  final RuleSystemId id;
  final String name;
  final String description;
  final String genre;
  final String imageAsset;
  final Map<String, StatDefinition> statSchema;
  final String icon;

  /// Opciones predefinidas de clase / ocupación para el sistema.
  final List<String> classes;

  /// Opciones predefinidas de raza / ancestría. Vacío si no aplica (ej. CoC).
  final List<String> races;

  /// Etiqueta del selector de clase (varía por sistema).
  final String classLabel;

  /// Etiqueta del selector de raza / ancestría.
  final String raceLabel;

  bool get hasRaces => races.isNotEmpty;

  String get idString => id.name;

  static RuleSystem fromId(RuleSystemId id) {
    return all.firstWhere((s) => s.id == id);
  }

  static RuleSystem fromString(String id) {
    return all.firstWhere((s) => s.idString == id);
  }

  static const List<RuleSystem> all = [_dnd5e, _pathfinder2e, _coc7e];

  // ─── D&D 5e ────────────────────────────────────────────────────────────────

  static const _dnd5eClasses = [
    'Bárbaro', 'Bardo', 'Clérigo', 'Druida', 'Guerrero', 'Monje',
    'Paladín', 'Explorador', 'Pícaro', 'Hechicero', 'Brujo', 'Mago',
  ];

  static const _dnd5eRaces = [
    'Humano', 'Elfo', 'Elfo del Bosque', 'Elfo Drow', 'Enano de las Colinas',
    'Enano de las Montañas', 'Mediano Pie Ligero', 'Mediano Robusto',
    'Gnomo de la Roca', 'Gnomo del Bosque', 'Semielfo', 'Semiorco',
    'Tiefling', 'Dracónido', 'Aasimar', 'Genasi del Fuego',
    'Genasi del Agua', 'Genasi de la Tierra', 'Genasi del Aire',
  ];

  static const _dnd5e = RuleSystem(
    id: RuleSystemId.dnd5e,
    name: 'Dungeons & Dragons 5e',
    description: 'Clásica fantasía épica con magia, dragones y aventuras legendarias.',
    genre: 'Fantasy',
    imageAsset: 'assets/images/DND_5E.png',
    icon: '⚔️',
    classLabel: 'Clase',
    raceLabel: 'Raza',
    classes: _dnd5eClasses,
    races: _dnd5eRaces,
    statSchema: {
      'STR': StatDefinition(label: 'Fuerza', min: 1, max: 20, type: StatType.attribute),
      'DEX': StatDefinition(label: 'Destreza', min: 1, max: 20, type: StatType.attribute),
      'CON': StatDefinition(label: 'Constitución', min: 1, max: 20, type: StatType.attribute),
      'INT': StatDefinition(label: 'Inteligencia', min: 1, max: 20, type: StatType.attribute),
      'WIS': StatDefinition(label: 'Sabiduría', min: 1, max: 20, type: StatType.attribute),
      'CHA': StatDefinition(label: 'Carisma', min: 1, max: 20, type: StatType.attribute),
      'HP': StatDefinition(label: 'Puntos de Vida', min: 0, max: 300, type: StatType.resource),
      'MAX_HP': StatDefinition(label: 'HP Máximo', min: 1, max: 300, type: StatType.resource),
      'AC': StatDefinition(label: 'Clase de Armadura', min: 1, max: 30, type: StatType.derived),
      'LEVEL': StatDefinition(label: 'Nivel', min: 1, max: 20, type: StatType.derived),
      'XP': StatDefinition(label: 'Experiencia', min: 0, max: 355000, type: StatType.resource),
    },
  );

  // ─── Pathfinder 2e ─────────────────────────────────────────────────────────

  static const _pf2eClasses = [
    'Alquimista', 'Bárbaro', 'Bardo', 'Campeón', 'Clérigo', 'Druida',
    'Guerrero', 'Investigador', 'Mago', 'Monje', 'Oráculo', 'Explorador',
    'Pícaro', 'Nigromante', 'Hechicero', 'Swashbuckler', 'Bruja',
    'Psíquico', 'Thaumaturge',
  ];

  static const _pf2eRaces = [
    'Humano', 'Elfo', 'Enano', 'Gnomo', 'Goblin', 'Mediano',
    'Hobgoblin', 'Leshy', 'Orco', 'Catfolk', 'Kobold', 'Ratfolk',
    'Tengu', 'Sprites', 'Fetchling', 'Fleshwarp', 'Grippli',
  ];

  static const _pathfinder2e = RuleSystem(
    id: RuleSystemId.pathfinder2e,
    name: 'Pathfinder 2e',
    description: 'Aventuras tácticas en el mundo de Golarion con un sistema detallado de acciones.',
    genre: 'Fantasy',
    imageAsset: 'assets/images/PATHFINDER_2E.png',
    icon: '🗡️',
    classLabel: 'Clase',
    raceLabel: 'Ancestría',
    classes: _pf2eClasses,
    races: _pf2eRaces,
    statSchema: {
      'STR': StatDefinition(label: 'Fuerza', min: 1, max: 20, type: StatType.attribute),
      'DEX': StatDefinition(label: 'Destreza', min: 1, max: 20, type: StatType.attribute),
      'CON': StatDefinition(label: 'Constitución', min: 1, max: 20, type: StatType.attribute),
      'INT': StatDefinition(label: 'Inteligencia', min: 1, max: 20, type: StatType.attribute),
      'WIS': StatDefinition(label: 'Sabiduría', min: 1, max: 20, type: StatType.attribute),
      'CHA': StatDefinition(label: 'Carisma', min: 1, max: 20, type: StatType.attribute),
      'HP': StatDefinition(label: 'Puntos de Vida', min: 0, max: 400, type: StatType.resource),
      'MAX_HP': StatDefinition(label: 'HP Máximo', min: 1, max: 400, type: StatType.resource),
      'AC': StatDefinition(label: 'Clase de Armadura', min: 1, max: 35, type: StatType.derived),
      'LEVEL': StatDefinition(label: 'Nivel', min: 1, max: 20, type: StatType.derived),
      'HERO_POINTS': StatDefinition(label: 'Puntos de Héroe', min: 0, max: 3, type: StatType.resource),
    },
  );

  // ─── Call of Cthulhu 7e ────────────────────────────────────────────────────

  static const _cocOccupations = [
    'Académico', 'Actor', 'Anticuario', 'Arqueólogo', 'Artista', 'Atleta',
    'Aventurero', 'Cazador', 'Científico', 'Clérigo', 'Conductor',
    'Criminólogo', 'Detective', 'Doctor / Médico', 'Enfermero/a',
    'Escritor', 'Espía', 'Granjero', 'Ingeniero', 'Marinero',
    'Militar / Oficial', 'Músico', 'Periodista', 'Piloto',
    'Policía / Detective', 'Psiquiatra', 'Sacerdote', 'Soldado',
    'Taxista', 'Trabajador Social',
  ];

  static const _coc7e = RuleSystem(
    id: RuleSystemId.callOfCthulhu7e,
    name: 'Call of Cthulhu 7e',
    description: 'Horror cósmico lovecraftiano. Investiga lo desconocido... si te atreves.',
    genre: 'Horror',
    imageAsset: 'assets/images/CALL_OF_CTHULHU_7E.png',
    icon: '🐙',
    classLabel: 'Ocupación',
    raceLabel: '',
    classes: _cocOccupations,
    races: const [],   // CoC: todos son humanos
    statSchema: {
      'STR': StatDefinition(label: 'Fuerza', min: 1, max: 100, type: StatType.attribute),
      'CON': StatDefinition(label: 'Constitución', min: 1, max: 100, type: StatType.attribute),
      'SIZ': StatDefinition(label: 'Tamaño', min: 1, max: 100, type: StatType.attribute),
      'DEX': StatDefinition(label: 'Destreza', min: 1, max: 100, type: StatType.attribute),
      'APP': StatDefinition(label: 'Apariencia', min: 1, max: 100, type: StatType.attribute),
      'INT': StatDefinition(label: 'Inteligencia', min: 1, max: 100, type: StatType.attribute),
      'POW': StatDefinition(label: 'Poder', min: 1, max: 100, type: StatType.attribute),
      'EDU': StatDefinition(label: 'Educación', min: 1, max: 100, type: StatType.attribute),
      'HP': StatDefinition(label: 'Puntos de Vida', min: 0, max: 20, type: StatType.resource),
      'MAX_HP': StatDefinition(label: 'HP Máximo', min: 1, max: 20, type: StatType.resource),
      'SAN': StatDefinition(label: 'Cordura', min: 0, max: 99, type: StatType.resource),
      'MAX_SAN': StatDefinition(label: 'Cordura Máxima', min: 0, max: 99, type: StatType.resource),
      'MP': StatDefinition(label: 'Puntos de Magia', min: 0, max: 20, type: StatType.resource),
      'LUCK': StatDefinition(label: 'Suerte', min: 0, max: 100, type: StatType.resource),
    },
  );
}

enum StatType { attribute, resource, derived }

class StatDefinition {
  const StatDefinition({
    required this.label,
    required this.min,
    required this.max,
    required this.type,
  });

  final String label;
  final int min;
  final int max;
  final StatType type;
}
