import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rol_genui/core/logging/app_logger.dart';
import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/character_feature.dart';
import 'package:rol_genui/domain/entities/combat.dart';
import 'package:rol_genui/domain/entities/game_session.dart';
import 'package:rol_genui/domain/entities/inventory.dart';
import 'package:rol_genui/domain/entities/item.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';
import 'package:rol_genui/domain/entities/spell.dart';
import 'package:rol_genui/domain/entities/story_message.dart';
import 'package:sqflite/sqflite.dart';

final _log = getLogger('DatabaseDataSource');

abstract class DatabaseDataSource {
  Future<void> init();

  // Characters
  Future<void> insertCharacter(Character character);
  Future<void> updateCharacter(Character character);
  Future<void> deleteCharacter(String id);
  Future<Character?> getCharacter(String id);
  Future<List<Character>> getCharactersBySystem(RuleSystemId systemId);

  // Sessions
  Future<void> insertSession(GameSession session);
  Future<void> updateSession(GameSession session);
  Future<void> deleteSession(String id);
  Future<GameSession?> getSession(String id);
  Future<List<GameSession>> getSessionsByCharacter(String characterId);

  // Messages
  Future<void> insertMessage(StoryMessage message);
  Future<List<StoryMessage>> getMessagesBySession(String sessionId);
  Future<void> deleteMessagesBySession(String sessionId);
}

class DatabaseDataSourceImpl implements DatabaseDataSource {
  Database? _db;

  @override
  Future<void> init() async {
    _log.info('Inicializando base de datos...');
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'rol_genui.db');
    _log.config('Ruta de la base de datos: $path');
    _db = await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    _log.info('Base de datos lista');
  }

  Database get db {
    if (_db == null) {
      _log.severe('Base de datos no inicializada. Llama a init() primero.');
      throw Exception('Database not initialized. Call init() first.');
    }
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    _log.info('Creando esquema de base de datos v$version...');
    await db.execute('''
      CREATE TABLE characters (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        rule_system_id TEXT NOT NULL,
        stats_json TEXT NOT NULL,
        backstory TEXT NOT NULL,
        character_class TEXT NOT NULL,
        race TEXT,
        occupation TEXT,
        image_prompt TEXT,
        inventory_json TEXT,
        features_json TEXT,
        spells_json TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE game_sessions (
        id TEXT PRIMARY KEY,
        character_id TEXT NOT NULL,
        rule_system_id TEXT NOT NULL,
        title TEXT NOT NULL,
        summary TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE session_messages (
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        role TEXT NOT NULL,
        text TEXT NOT NULL,
        choices_json TEXT,
        selected_choice_index INTEGER,
        character_updates_json TEXT,
        inventory_updates_json TEXT,
        combat_state_json TEXT,
        timestamp INTEGER NOT NULL,
        FOREIGN KEY (session_id) REFERENCES game_sessions(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_characters_system ON characters(rule_system_id)');
    await db.execute('CREATE INDEX idx_sessions_character ON game_sessions(character_id)');
    await db.execute('CREATE INDEX idx_messages_session ON session_messages(session_id)');
    _log.info('Esquema creado correctamente');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _log.info('Migrando base de datos v$oldVersion → v$newVersion...');
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE characters ADD COLUMN inventory_json TEXT');
      await db.execute('ALTER TABLE session_messages ADD COLUMN inventory_updates_json TEXT');
      await db.execute('ALTER TABLE session_messages ADD COLUMN combat_state_json TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE characters ADD COLUMN features_json TEXT');
      await db.execute('ALTER TABLE characters ADD COLUMN spells_json TEXT');
    }
    _log.info('Migración v$newVersion completa');
  }

  // ── Characters ──────────────────────────────────────────────────────────────

  @override
  Future<void> insertCharacter(Character character) async {
    _log.fine('Insertando personaje id=${character.id} name="${character.name}"');
    try {
      await db.insert('characters', _characterToMap(character),
          conflictAlgorithm: ConflictAlgorithm.replace);
      _log.info('Personaje creado: "${character.name}" [${character.ruleSystemId.name}]');
    } catch (e, st) {
      _log.severe('Error insertando personaje "${character.name}"', e, st);
      rethrow;
    }
  }

  @override
  Future<void> updateCharacter(Character character) async {
    _log.fine('Actualizando personaje id=${character.id}');
    try {
      await db.update('characters', _characterToMap(character),
          where: 'id = ?', whereArgs: [character.id]);
      _log.info('Personaje actualizado: "${character.name}"');
    } catch (e, st) {
      _log.severe('Error actualizando personaje id=${character.id}', e, st);
      rethrow;
    }
  }

  @override
  Future<void> deleteCharacter(String id) async {
    _log.fine('Eliminando personaje id=$id');
    try {
      await db.delete('characters', where: 'id = ?', whereArgs: [id]);
      _log.info('Personaje eliminado: id=$id');
    } catch (e, st) {
      _log.severe('Error eliminando personaje id=$id', e, st);
      rethrow;
    }
  }

  @override
  Future<Character?> getCharacter(String id) async {
    _log.fine('Buscando personaje id=$id');
    final rows = await db.query('characters', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) {
      _log.warning('Personaje no encontrado: id=$id');
      return null;
    }
    return _characterFromMap(rows.first);
  }

  @override
  Future<List<Character>> getCharactersBySystem(RuleSystemId systemId) async {
    _log.fine('Cargando personajes del sistema ${systemId.name}');
    final rows = await db.query('characters',
        where: 'rule_system_id = ?',
        whereArgs: [systemId.name],
        orderBy: 'updated_at DESC');
    _log.info('Personajes cargados: ${rows.length} para ${systemId.name}');
    return rows.map(_characterFromMap).toList();
  }

  // ── Sessions ─────────────────────────────────────────────────────────────────

  @override
  Future<void> insertSession(GameSession session) async {
    _log.fine('Insertando sesión id=${session.id} title="${session.title}"');
    try {
      await db.insert('game_sessions', _sessionToMap(session),
          conflictAlgorithm: ConflictAlgorithm.replace);
      _log.info('Sesión creada: "${session.title}"');
    } catch (e, st) {
      _log.severe('Error insertando sesión "${session.title}"', e, st);
      rethrow;
    }
  }

  @override
  Future<void> updateSession(GameSession session) async {
    _log.fine('Actualizando sesión id=${session.id}');
    try {
      await db.update('game_sessions', _sessionToMap(session),
          where: 'id = ?', whereArgs: [session.id]);
    } catch (e, st) {
      _log.severe('Error actualizando sesión id=${session.id}', e, st);
      rethrow;
    }
  }

  @override
  Future<void> deleteSession(String id) async {
    _log.fine('Eliminando sesión id=$id');
    try {
      await db.delete('game_sessions', where: 'id = ?', whereArgs: [id]);
      _log.info('Sesión eliminada: id=$id');
    } catch (e, st) {
      _log.severe('Error eliminando sesión id=$id', e, st);
      rethrow;
    }
  }

  @override
  Future<GameSession?> getSession(String id) async {
    _log.fine('Buscando sesión id=$id');
    final rows =
        await db.query('game_sessions', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) {
      _log.warning('Sesión no encontrada: id=$id');
      return null;
    }
    return _sessionFromMap(rows.first);
  }

  @override
  Future<List<GameSession>> getSessionsByCharacter(String characterId) async {
    _log.fine('Cargando sesiones del personaje id=$characterId');
    final rows = await db.query('game_sessions',
        where: 'character_id = ?',
        whereArgs: [characterId],
        orderBy: 'updated_at DESC');
    _log.info('Sesiones cargadas: ${rows.length} para personaje $characterId');
    return rows.map(_sessionFromMap).toList();
  }

  // ── Messages ─────────────────────────────────────────────────────────────────

  @override
  Future<void> insertMessage(StoryMessage message) async {
    _log.fine('Insertando mensaje id=${message.id} role=${message.role.name}');
    try {
      await db.insert('session_messages', _messageToMap(message),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e, st) {
      _log.severe('Error insertando mensaje id=${message.id}', e, st);
      rethrow;
    }
  }

  @override
  Future<List<StoryMessage>> getMessagesBySession(String sessionId) async {
    _log.fine('Cargando mensajes de sesión id=$sessionId');
    final rows = await db.query('session_messages',
        where: 'session_id = ?',
        whereArgs: [sessionId],
        orderBy: 'timestamp ASC');
    _log.info('Mensajes cargados: ${rows.length} para sesión $sessionId');
    return rows.map(_messageFromMap).toList();
  }

  @override
  Future<void> deleteMessagesBySession(String sessionId) async {
    _log.fine('Eliminando mensajes de sesión id=$sessionId');
    await db.delete('session_messages',
        where: 'session_id = ?', whereArgs: [sessionId]);
    _log.info('Mensajes eliminados para sesión $sessionId');
  }

  // ── Mappers ──────────────────────────────────────────────────────────────────

  Map<String, dynamic> _characterToMap(Character c) => {
    'id': c.id,
    'name': c.name,
    'rule_system_id': c.ruleSystemId.name,
    'stats_json': jsonEncode(c.stats),
    'backstory': c.backstory,
    'character_class': c.characterClass,
    'race': c.race,
    'occupation': c.occupation,
    'image_prompt': c.imagePrompt,
    'inventory_json': jsonEncode(c.inventory.map((e) => e.toJson()).toList()),
    'features_json': jsonEncode(c.features.map((e) => e.toJson()).toList()),
    'spells_json': jsonEncode(c.spells.map((e) => e.toJson()).toList()),
    'created_at': c.createdAt.millisecondsSinceEpoch,
    'updated_at': c.updatedAt.millisecondsSinceEpoch,
  };

  Character _characterFromMap(Map<String, dynamic> m) => Character(
    id: m['id'] as String,
    name: m['name'] as String,
    ruleSystemId: RuleSystemId.values.firstWhere((e) => e.name == m['rule_system_id']),
    stats: Map<String, int>.from(jsonDecode(m['stats_json'] as String) as Map),
    backstory: m['backstory'] as String,
    characterClass: m['character_class'] as String,
    race: m['race'] as String?,
    occupation: m['occupation'] as String?,
    imagePrompt: m['image_prompt'] as String?,
    inventory: m['inventory_json'] != null
        ? (jsonDecode(m['inventory_json'] as String) as List)
            .map((e) => Item.fromJson(e as Map<String, dynamic>))
            .toList()
        : const [],
    features: m['features_json'] != null
        ? (jsonDecode(m['features_json'] as String) as List)
            .map((e) => CharacterFeature.fromJson(e as Map<String, dynamic>))
            .toList()
        : const [],
    spells: m['spells_json'] != null
        ? (jsonDecode(m['spells_json'] as String) as List)
            .map((e) => Spell.fromJson(e as Map<String, dynamic>))
            .toList()
        : const [],
    createdAt: DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(m['updated_at'] as int),
  );

  Map<String, dynamic> _sessionToMap(GameSession s) => {
    'id': s.id,
    'character_id': s.characterId,
    'rule_system_id': s.ruleSystemId.name,
    'title': s.title,
    'summary': s.summary,
    'is_active': s.isActive ? 1 : 0,
    'created_at': s.createdAt.millisecondsSinceEpoch,
    'updated_at': s.updatedAt.millisecondsSinceEpoch,
  };

  GameSession _sessionFromMap(Map<String, dynamic> m) => GameSession(
    id: m['id'] as String,
    characterId: m['character_id'] as String,
    ruleSystemId: RuleSystemId.values.firstWhere((e) => e.name == m['rule_system_id']),
    title: m['title'] as String,
    summary: m['summary'] as String,
    isActive: (m['is_active'] as int) == 1,
    createdAt: DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(m['updated_at'] as int),
  );

  Map<String, dynamic> _messageToMap(StoryMessage msg) => {
    'id': msg.id,
    'session_id': msg.sessionId,
    'role': msg.role.name,
    'text': msg.text,
    'choices_json': msg.choices != null ? jsonEncode(msg.choices) : null,
    'selected_choice_index': msg.selectedChoiceIndex,
    'character_updates_json':
        msg.characterUpdates != null ? jsonEncode(msg.characterUpdates) : null,
    'inventory_updates_json':
        msg.inventoryUpdates != null ? jsonEncode(msg.inventoryUpdates!.map((e) => e.toJson()).toList()) : null,
    'combat_state_json':
        msg.combatState != null ? jsonEncode(msg.combatState!.toJson()) : null,
    'timestamp': msg.timestamp.millisecondsSinceEpoch,
  };

  StoryMessage _messageFromMap(Map<String, dynamic> m) => StoryMessage(
    id: m['id'] as String,
    sessionId: m['session_id'] as String,
    role: MessageRole.values.firstWhere((e) => e.name == m['role']),
    text: m['text'] as String,
    choices: m['choices_json'] != null
        ? List<String>.from(jsonDecode(m['choices_json'] as String) as List)
        : null,
    selectedChoiceIndex: m['selected_choice_index'] as int?,
    characterUpdates: m['character_updates_json'] != null
        ? Map<String, int>.from(jsonDecode(m['character_updates_json'] as String) as Map)
        : null,
    inventoryUpdates: m['inventory_updates_json'] != null
        ? (jsonDecode(m['inventory_updates_json'] as String) as List)
            .map((e) => InventoryUpdate.fromJson(e as Map<String, dynamic>))
            .toList()
        : null,
    combatState: m['combat_state_json'] != null
        ? CombatState.fromJson(jsonDecode(m['combat_state_json'] as String) as Map<String, dynamic>)
        : null,
    timestamp: DateTime.fromMillisecondsSinceEpoch(m['timestamp'] as int),
  );
}
