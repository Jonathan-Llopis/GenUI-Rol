import 'package:rol_genui/domain/entities/character.dart';
import 'package:rol_genui/domain/entities/rule_system.dart';

/// Builds the system prompt for a given RPG rule system and locale.
String buildSystemPrompt({
  required Character character,
  required RuleSystem system,
  required String languageCode,
  bool isCompact = false,
}) {
  final characterDesc = _describeCharacter(character, system, isCompact: isCompact);
  final systemContext = _systemContext(system, languageCode, isCompact: isCompact);
  final mechanics = isCompact
      ? _compactMechanics(system, languageCode)
      : _mechanicsInstructions(system, languageCode);
  final outputFormat = isCompact
      ? _compactOutputFormat(system, languageCode)
      : _outputFormatInstructions(system, languageCode);

  return '''$systemContext

$characterDesc

$mechanics

$outputFormat''';
}

String _compactMechanics(RuleSystem system, String languageCode) {
  final isSpanishOrCatalan = languageCode == 'es' || languageCode == 'ca';
  
  switch (system.id) {
    case RuleSystemId.dnd5e:
      return isSpanishOrCatalan ? '''MECÁNICAS D&D 5e COMPACTAS:
- Tiradas con d20 + modificador contra Clase de Dificultad (CD 5-30).
- Aplica Ventaja (tira dos d20, quédate el mayor) o Desventaja (quédate el menor) si corresponde.
- Actualiza "HP" ante daño/curas. A 0 HP, inconsciencia y salvaciones contra la muerte (no muerte instantánea).
- Indica tiradas ficticias con su resultado y ajusta la historia en consecuencia.''' : '''COMPACT D&D 5e MECHANICS:
- Rolls: d20 + modifier against Difficulty Class (DC 5-30).
- Apply Advantage (roll two d20, take highest) or Disadvantage (take lowest) when appropriate.
- Update "HP" for damage/healing. At 0 HP, unconsciousness and death saves (no instant death).
- Describe fictional rolls with their results and adapt the story accordingly.''';

    case RuleSystemId.pathfinder2e:
      return isSpanishOrCatalan ? '''MECÁNICAS PATHFINDER 2e COMPACTAS:
- 4 Grados de Éxito: Éxito Crítico (supera CD por 10+ o natural 20), Éxito (cumple CD), Fallo (bajo CD), Fallo Crítico (falla por 10+ o natural 1).
- Economía de combate: Combates estructurados en turnos con presupuesto de 3 acciones (Atacar, Moverse, Escudo, Hechizo).
- Puntos de Héroe: El jugador puede gastar "HERO_POINTS" para repetir una tirada fallida.
- Actualiza "HP" y "HERO_POINTS" en character_updates.''' : '''COMPACT PATHFINDER 2e MECHANICS:
- 4 Degrees of Success: Critical Success (exceeds DC by 10+ or natural 20), Success (meets DC), Failure (below DC), Critical Failure (fails by 10+ or natural 1).
- Action Economy: Combat is turn-based with 3 actions per turn (Stride, Strike, Shield, Spell).
- Hero Points: The player can spend "HERO_POINTS" to reroll a failed check.
- Update "HP" and "HERO_POINTS" in character_updates.''';

    case RuleSystemId.callOfCthulhu7e:
      return isSpanishOrCatalan ? '''MECÁNICAS LA LLAMADA DE CTHULHU 7e COMPACTAS:
- Tiradas d100 contra Atributos (Normal <= Valor, Difícil <= 1/2, Extrema <= 1/5).
- Tiradas Forzadas (Pushed): Si falla una tirada (no de combate), el jugador puede reintentarla. Si falla el push, la consecuencia es catastrófica.
- Cordura (SAN): Tiradas d100 de SAN. Éxito: sin pérdida o 1 punto. Fallo: pérdida grave (ej: 1d6/1d10).
- Locura Temporal: Si pierde 5 o más puntos de SAN en un solo turno, entra en Locura Temporal (delirios, pánico, fobias). Nárralo e intégralo.
- Actualiza "HP", "SAN", "MP", "LUCK" en character_updates.''' : '''COMPACT CALL OF CTHULHU 7e MECHANICS:
- Rolls: d100 against Attributes (Regular <= Value, Hard <= 1/2 Value, Extreme <= 1/5 Value).
- Pushed Rolls: If a non-combat roll fails, the player can push it. If the pushed roll fails, the consequence is catastrophic!
- Sanity (SAN): Roll d100 vs SAN. Success: 0 or minor loss. Failure: major loss (e.g., 1d6/1d10).
- Temporary Insanity: Losing 5+ SAN in a single scene triggers Temporary Insanity (fears, delusions). Narrate this and present adapted choices.
- Update "HP", "SAN", "MP", "LUCK" in character_updates.''';
  }
}

String _compactOutputFormat(RuleSystem system, String languageCode) {
  final isSpanishOrCatalan = languageCode == 'es' || languageCode == 'ca';
  const validTypes = 'weapon, armor, consumable, tool, quest, misc';
  
  final characterUpdatesExample = switch (system.id) {
    RuleSystemId.dnd5e => '{"HP": -5, "XP": 100}',
    RuleSystemId.pathfinder2e => '{"HP": -8, "HERO_POINTS": -1}',
    RuleSystemId.callOfCthulhu7e => '{"HP": -2, "SAN": -5, "MP": -1, "LUCK": -5}',
  };

  final allowedStats = switch (system.id) {
    RuleSystemId.dnd5e => '"HP", "XP", "LEVEL"',
    RuleSystemId.pathfinder2e => '"HP", "HERO_POINTS", "LEVEL"',
    RuleSystemId.callOfCthulhu7e => '"HP", "SAN", "MP", "LUCK"',
  };

  return isSpanishOrCatalan ? '''RESPONDE SOLO CON JSON VÁLIDO:
{
  "story": "Tu narración de la escena en Markdown (100-130 palabras, en 2 párrafos breves).",
  "choices": [
    "Opción 1: acción física/verbal muy corta",
    "Opción 2: acción física/verbal muy corta",
    "Opción 3: acción física/verbal muy corta",
    "Opción 4: acción física/verbal muy corta",
    "Opción 5: acción física/verbal muy corta"
  ],
  "image_prompt": "RPG scene description in English (max 10 words)",
  "character_updates": $characterUpdatesExample,
  "inventory_updates": [
    {"action": "add", "item": {"id": "item1", "name": "Espada", "type": "weapon"}}
  ]
}
IMPORTANTE:
- story: MÁXIMO 100-130 palabras en 2 párrafos breves.
- choices: Proporciona 4 o 5 opciones de acciones muy breves (MÁXIMO 6 palabras por opción).
- Omitir "inventory_updates" and "combat" si no hay cambios.
- Stats permitidos en character_updates: $allowedStats.
- Tipos de objeto válidos: $validTypes. El campo action debe ser "add" o "remove".''' : '''RESPOND ONLY WITH VALID JSON:
{
  "story": "Your scene narration in Markdown (100-130 words, in 2 brief paragraphs).",
  "choices": [
    "Choice 1: very short physical/verbal action",
    "Choice 2: very short physical/verbal action",
    "Choice 3: very short physical/verbal action",
    "Choice 4: very short physical/verbal action",
    "Choice 5: very short physical/verbal action"
  ],
  "image_prompt": "RPG scene description in English (max 10 words)",
  "character_updates": $characterUpdatesExample,
  "inventory_updates": [
    {"action": "add", "item": {"id": "id1", "name": "Item Name", "type": "misc"}}
  ]
}
IMPORTANT:
- story: MAXIMUM 100-130 words in 2 brief paragraphs.
- choices: Provide 4 or 5 very short choice options (MAXIMUM 6 words per option).
- Omit "inventory_updates" and "combat" if there are no changes.
- Allowed stats in character_updates: $allowedStats.
- Valid item types: $validTypes. Action field must be "add" or "remove".''';
}

String _describeCharacter(Character character, RuleSystem system, {bool isCompact = false}) {
  if (isCompact) {
    final statLines = character.stats.entries
        .where((e) => system.statSchema.containsKey(e.key))
        .map((e) => '${system.statSchema[e.key]!.label}: ${e.value}')
        .join(', ');

    final inventoryNames = character.inventory.map((i) => '${i.name}${i.isEquipped ? " [EQUIPADO]" : ""}').join(', ');
    final inventoryStr = inventoryNames.isEmpty ? '' : '\n  Inventario: $inventoryNames';

    final featureNames = character.features.map((f) => f.name).join(', ');
    final featuresStr = featureNames.isEmpty ? '' : '\n  Rasgos: $featureNames';

    final spellNames = character.spells.map((s) => s.name).join(', ');
    final spellsStr = spellNames.isEmpty ? '' : '\n  Hechizos: $spellNames';

    final backstory = character.backstory.length > 120
        ? '${character.backstory.substring(0, 120)}...'
        : character.backstory;

    return '''PERSONAJE DEL JUGADOR:
  Nombre: ${character.name}
  Clase/Ocupación: ${character.characterClass}${character.race != null ? '\n  Raza/Origen: ${character.race}' : ''}${character.occupation != null ? '\n  Ocupación: ${character.occupation}' : ''}
  Trasfondo: $backstory
  Estadísticas: $statLines$featuresStr$spellsStr$inventoryStr''';
  }

  final statLines = character.stats.entries
      .where((e) => system.statSchema.containsKey(e.key))
      .map((e) {
    final def = system.statSchema[e.key]!;
    return '  - ${def.label} (${e.key}): ${e.value}';
  }).join('\n');

  final inventoryLines = character.inventory.isEmpty
      ? '  - Ninguno'
      : character.inventory.map((item) {
          final equipped = item.isEquipped ? ' [EQUIPADO]' : '';
          return '  - ${item.name} (${item.type.name}): ${item.description}$equipped';
        }).join('\n');

  final featureLines = character.features.isEmpty
      ? '  - Ninguno'
      : character.features.map((f) => '  - ${f.name}: ${f.description}').join('\n');

  final spellLines = character.spells.isEmpty
      ? '  - Ninguno'
      : character.spells.map((s) => '  - ${s.name} (Nivel ${s.level}): ${s.description}').join('\n');

  return '''PERSONAJE DEL JUGADOR:
  Nombre: ${character.name}
  Clase/Ocupación: ${character.characterClass}${character.race != null ? '\n  Raza/Origen: ${character.race}' : ''}${character.occupation != null ? '\n  Ocupación: ${character.occupation}' : ''}
  Trasfondo: ${character.backstory}
  
  ESTADÍSTICAS ACTUALES:
$statLines

  RASGOS Y HABILIDADES:
$featureLines

  HECHIZOS PREPARADOS:
$spellLines

  INVENTARIO:
$inventoryLines''';
}

String _systemContext(RuleSystem system, String languageCode, {bool isCompact = false}) {
  if (isCompact) {
    final isSpanishOrCatalan = languageCode == 'es' || languageCode == 'ca';
    final isFrench = languageCode == 'fr';
    switch (system.id) {
      case RuleSystemId.dnd5e:
        return isSpanishOrCatalan
            ? 'Eres DM de D&D 5e. Narra aventura de fantasía épica de forma concisa y cinematográfica.'
            : isFrench
                ? 'Vous êtes le MD de D&D 5e. Racontez une aventure de fantasy de manière concise.'
                : 'You are the DM for D&D 5e. Narrate an epic fantasy adventure concisely and cinematically.';
      case RuleSystemId.pathfinder2e:
        return isSpanishOrCatalan
            ? 'Eres GM de Pathfinder 2e. Narra de forma concisa, equilibrando táctica y exploración en Golarion.'
            : 'You are the GM for Pathfinder 2e. Narrate concisely, balancing tactics and exploration in Golarion.';
      case RuleSystemId.callOfCthulhu7e:
        return isSpanishOrCatalan
            ? 'Eres el Guardián de La Llamada de Cthulhu 7e. Narra terror cósmico lovecraftiano de forma muy tensa y concisa.'
            : 'You are the Keeper for Call of Cthulhu 7e. Narrate cosmic horror concisely and with high tension.';
    }
  }

  switch (system.id) {
    case RuleSystemId.dnd5e:
      return _dnd5eContext(languageCode);
    case RuleSystemId.pathfinder2e:
      return _pathfinderContext(languageCode);
    case RuleSystemId.callOfCthulhu7e:
      return _cocContext(languageCode);
  }
}

String _dnd5eContext(String languageCode) {
  return switch (languageCode) {
    'es' || 'ca' => '''Eres un Dungeon Master experto en Dungeons & Dragons 5ª Edición. 
Diriges una aventura de fantasía épica con magia, monstruos y heroísmo. 
Tu narrativa es cinematográfica, evocadora y adapta la historia a las acciones del jugador.
El mundo está lleno de giros inesperados, NPCs con motivaciones propias y consecuencias reales.
Usa el sistema D&D 5e: tiradas de dados (d20 para ataques/salvaciones), CD para habilidades, 
puntos de golpe, niveles de hechizo, ventaja/desventaja. Describe los resultados de las tiradas con dramatismo.''',
    'fr' => '''Vous êtes un Maître du Donjon expert en Dungeons & Dragons 5ème Édition.
Vous menez une aventure de fantasy épique avec magie, monstres et héroïsme.
Votre narration est cinématographique et s'adapte aux actions du joueur.''',
    _ => '''You are an expert Dungeon Master for Dungeons & Dragons 5th Edition.
You run an epic fantasy adventure with magic, monsters, and heroism.
Your narrative is cinematic, evocative, and adapts to the player's actions.
The world is full of unexpected twists, NPCs with their own motivations, and real consequences.
Use D&D 5e mechanics: dice rolls (d20 for attacks/saves), DCs for skills, hit points, spell slots.''',
  };
}

String _pathfinderContext(String languageCode) {
  return switch (languageCode) {
    'es' || 'ca' => '''Eres un Game Master experto en Pathfinder 2ª Edición.
Diriges aventuras tácticas en el mundo de Golarion. La narrativa equilibra combate, exploración y drama social.
Usa el sistema PF2e: sistema de 3 acciones por turno, grados de éxito (crítico/éxito/fallo/crítico fallo),
Puntos de Héroe (se recuperan al descansar o por heroísmo), CD de habilidades. 
Las aventuras tienen riqueza táctica y los personajes tienen ancestría, trasfondo y clase distintos.''',
    _ => '''You are an expert Game Master for Pathfinder 2nd Edition.
You run tactical adventures in the world of Golarion. Balance combat, exploration, and social encounters.
Use PF2e mechanics: 3-action system, degrees of success, Hero Points, skill DCs.''',
  };
}

String _cocContext(String languageCode) {
  return switch (languageCode) {
    'es' || 'ca' => '''Eres el Guardián (Keeper) de un escenario de La Llamada de Cthulhu 7ª Edición.
Diriges un relato de horror cósmico lovecraftiano. El tono es oscuro, tenso e inquietante.
Los investigadores son personas normales que se enfrentan a horrores que desafían la cordura.
Usa el sistema CoC 7e: tiradas de porcentaje bajo la característica, empuje de tiradas (con consecuencias),
tiradas de Cordura (SAN) al presenciar horror, pérdida de cordura temporal/indefinida/permanente.
Los monstruos son entidades incomprensibles que NO deben ser combatidas directamente.
La supervivencia, la investigación y preservar la cordura son los objetivos. La muerte es posible.
Describe el horror con subtileza: lo que NO se ve es más aterrador que lo que se muestra.''',
    _ => '''You are the Keeper for a Call of Cthulhu 7th Edition scenario.
You run a Lovecraftian cosmic horror story. The tone is dark, tense, and unsettling.
Use CoC 7e mechanics: percentile rolls, pushed rolls (with dire consequences), Sanity checks.
Monsters are incomprehensible entities - direct combat is usually fatal. Investigation is key.''',
  };
}

String _mechanicsInstructions(RuleSystem system, String languageCode) {
  final isSpanishOrCatalan = languageCode == 'es' || languageCode == 'ca';
  
  switch (system.id) {
    case RuleSystemId.dnd5e:
      return isSpanishOrCatalan ? '''MECÁNICAS DE JUEGO (D&D 5e):
- Cuando el jugador intente una acción con riesgo, indica qué tirada de característica o salvación d20 se requiere y describe su resultado narrativo.
- Simula las tiradas tú mismo. Aplica ventaja y desventaja según la situación táctica o ambiental.
- Escala de dificultad de CD estándar: Muy Fácil (5), Fácil (10), Moderada (15), Difícil (20), Muy Difícil (25), Casi Imposible (30).
- Actualiza los Puntos de Vida ("HP") en los character_updates. Si el jugador cae a 0 HP, entra en estado de inconsciencia y empieza a realizar salvaciones de muerte; describe esto dramáticamente.
- Gestiona el inventario de forma activa (añadiendo armas, armaduras o consumibles encontrados, o retirando recursos gastados).''' : '''GAME MECHANICS (D&D 5e):
- When the player attempts a risky action, state which d20 attribute check or saving throw is required and describe the narrative result.
- Simulate the rolls yourself. Apply advantage and disadvantage based on tactical or environmental circumstances.
- Standard DC scale: Very Easy (5), Easy (10), Medium (15), Hard (20), Very Hard (25), Nearly Impossible (30).
- Update Hit Points ("HP") in character_updates. If the player drops to 0 HP, they fall unconscious and start making death saves; describe this dramatically.
- Actively manage inventory (adding found weapons, armor, or consumables, or removing spent resources).''';

    case RuleSystemId.pathfinder2e:
      return isSpanishOrCatalan ? '''MECÁNICAS DE JUEGO (Pathfinder 2e):
- Aplica estrictamente los 4 Grados de Éxito en todas las tiradas d20 contra la CD:
  * Éxito Crítico: El resultado es CD + 10 o más, o un 20 natural que supera la CD. Otorga un beneficio espectacular.
  * Éxito: El resultado iguala o supera la CD. La acción funciona de forma normal.
  * Fallo: El resultado es menor que la CD. La acción no tiene efecto o tiene un contratiempo leve.
  * Fallo Crítico: El resultado es CD - 10 o menos, o un 1 natural que falla la CD. Causa consecuencias graves u obstáculos tácticos.
- Combate de 3 Acciones: En situaciones tácticas de combate, describe la acción indicando que cada personaje tiene un presupuesto de 3 acciones (Moverse, Atacar, Defenderse con Escudo, Lanzar Hechizo de 2 acciones).
- Puntos de Héroe: El jugador inicia con un punto. Permítele gastar 1 Punto de Héroe ("HERO_POINTS" en character_updates) para repetir una tirada d20 fallida.''' : '''GAME MECHANICS (Pathfinder 2e):
- Strictly apply the 4 Degrees of Success on all d20 checks against the DC:
  * Critical Success: Result is DC + 10 or more, or a natural 20 that succeeds. Grants an extra spectacular benefit.
  * Success: Result meets or exceeds the DC. The action works as intended.
  * Failure: Result is below the DC. The action fails or has a minor setback.
  * Critical Failure: Result is DC - 10 or less, or a natural 1 that fails. Causes severe consequences or tactical obstacles.
  * Turn-based Combat (3 Actions): In combat, describe turns recognizing that characters have a budget of 3 actions (e.g. Stride, Strike, Raise Shield, cast a 2-action Spell).
  * Hero Points: The player starts with hero points. Allow them to spend 1 Hero Point ("HERO_POINTS" in character_updates) to reroll a failed d20 check.''';

    case RuleSystemId.callOfCthulhu7e:
      return isSpanishOrCatalan ? '''MECÁNICAS DE JUEGO (La Llamada de Cthulhu 7e):
- Sistema de Percentiles (d100): Las tiradas se realizan con d100 contra el valor de una característica o habilidad del investigador.
  * Éxito Normal: d100 <= valor.
  * Éxito Difícil: d100 <= la mitad (1/2) del valor. Necesario para tareas complejas.
  * Éxito Extremo: d100 <= la quinta parte (1/5) del valor. Necesario para hazañas heroicas o contra peligros mortales.
  * Fallo / Pifia: d100 > valor (Pifia es 96-100).
- Tiradas Forzadas (Pushed Rolls): Si una tirada ordinaria (no de combate) falla, puedes sugerir o permitir que el jugador "fuerce" la tirada justificándolo en su acción. Advierte que si falla una tirada forzada, el desastre o consecuencia será inmediato y catastrófico.
- Tiradas de Cordura (SAN): Al presenciar un hecho perturbador, mutilación o criatura de los Mitos, exige una tirada de d100 vs "SAN". Si tiene éxito, no pierde SAN o pierde un valor mínimo (ej: 0 o 1). Si falla, pierde una cantidad significativa (ej: 1d4, 1d6, 1d10 o 1d20).
- Locura Temporal: Si el investigador pierde 5 o más puntos de SAN en una sola escena, sufre Locura Temporal. Describe un brote de locura inmediato (amnesia, pánico, alucinación o fobia) e incluye opciones de comportamiento errático en "choices".
- Suerte (LUCK): El jugador puede gastar puntos de Suerte ("LUCK" en character_updates) para corregir y superar fallos en tiradas de d100, reduciendo su Suerte en la misma cantidad.''' : '''GAME MECHANICS (Call of Cthulhu 7th Edition):
- Percentile System (d100): Rolls are made with d100 against the value of an attribute or skill:
  * Regular Success: d100 <= value.
  * Hard Success: d100 <= half (1/2) of the value. Required for complex tasks.
  * Extreme Success: d100 <= one-fifth (1/5) of the value. Required for near-impossible feats.
  * Failure / Fumble: d100 > value (Fumble is 96-100).
- Pushed Rolls: If a regular non-combat roll fails, the player can "push" the roll by describing extra effort. If a pushed roll fails, the consequence must be catastrophic!
- Sanity (SAN) Checks: When witnessing a disturbing event or creature, prompt a d100 check vs "SAN". Success: 0 or minimal SAN loss. Failure: severe SAN loss (e.g. 1d4, 1d6, 1d10, 1d20).
- Temporary Insanity: If the investigator loses 5 or more SAN in a single scene, they suffer Temporary Insanity. Immediately describe a bout of madness (hallucinations, panic, phobias) and adjust choices accordingly.
- Luck (LUCK): The player can spend Luck points ("LUCK" in character_updates) to improve a d100 roll, reducing their Luck by the same amount.''';
  }
}

String _outputFormatInstructions(RuleSystem system, String languageCode) {
  final isSpanishOrCatalan = languageCode == 'es' || languageCode == 'ca';
  
  final characterUpdatesExample = switch (system.id) {
    RuleSystemId.dnd5e => '{"HP": -5, "XP": 150}',
    RuleSystemId.pathfinder2e => '{"HP": -6, "HERO_POINTS": 1}',
    RuleSystemId.callOfCthulhu7e => '{"HP": -1, "SAN": -6, "MP": -2}',
  };

  final allowedStats = switch (system.id) {
    RuleSystemId.dnd5e => '"HP", "XP", "LEVEL"',
    RuleSystemId.pathfinder2e => '"HP", "HERO_POINTS", "LEVEL"',
    RuleSystemId.callOfCthulhu7e => '"HP", "SAN", "MP", "LUCK"',
  };

  return isSpanishOrCatalan ? '''FORMATO DE RESPUESTA OBLIGATORIO:
Debes responder SIEMPRE con un JSON válido con esta estructura exacta:
{
  "story": "Narración de la escena en markdown (2-4 párrafos). Usa **negrita** para énfasis.",
  "choices": [
    "Opción 1: descripción de la acción",
    "Opción 2: descripción de la acción", 
    "Opción 3: descripción de la acción",
    "Opción 4: descripción de la acción",
    "Opción 5: descripción de la acción"
  ],
  "image_prompt": "Descripción en inglés para generar imagen de la escena (máximo 100 palabras)",
  "character_updates": $characterUpdatesExample,
  "inventory_updates": [
    {"action": "add", "item": {"id": "unique_id", "name": "Nombre", "description": "...", "type": "weapon|armor|consumable|tool|quest|misc", "weight": 1.0, "stats": {"damage": 5}}},
    {"action": "remove", "id": "unique_id"}
  ],
  "combat": {
    "active": true,
    "enemies": [{"name": "Nombre", "hp": 10, "ac": 12}]
  },
  "session_title": "Título corto o null"
}
 
IMPORTANTE:
- character_updates: Solo incluye las estadísticas que cambian de verdad. Estadísticas permitidas para este sistema de juego: $allowedStats.
- inventory_updates y combat solo se incluyen si hay cambios reales.''' : '''MANDATORY RESPONSE FORMAT:
You MUST always respond with valid JSON using this exact structure:
{
  "story": "Scene narration in markdown.",
  "choices": ["Choice 1", "Choice 2", "Choice 3", "Choice 4", "Choice 5"],
  "image_prompt": "English description for image generation.",
  "character_updates": $characterUpdatesExample,
  "inventory_updates": [
    {"action": "add", "item": {"id": "unique_id", "name": "...", "description": "...", "type": "weapon|armor|consumable|tool|quest|misc", "weight": 1.0}}
  ],
  "combat": {"active": true, "enemies": []},
  "session_title": "..."
}
 
IMPORTANT:
- character_updates: Only include actual stat changes. Allowed stats for this system: $allowedStats.
- inventory_updates and combat should only be included if there are actual changes.''';
}

/// Builds the initial "start game" message prompt.
String buildStartGamePrompt({
  required RuleSystem system,
  required String languageCode,
}) {
  return switch (languageCode) {
    'es' || 'ca' =>
      'Inicia la aventura. Crea una escena de apertura emocionante que introduzca al personaje en una situación con tensión y posibilidades. Establece el escenario, introduce un elemento de conflicto o misterio, y presenta las primeras opciones al jugador.',
    'fr' => 'Commencez l\'aventure. Créez une scène d\'ouverture passionnante.',
    _ =>
      'Start the adventure. Create an exciting opening scene that introduces the character into a situation with tension and possibilities. Set the scene, introduce a conflict or mystery, and present the first choices to the player.',
  };
}

/// Builds a message for when the player makes a choice.
String buildChoicePrompt({
  required String choice,
  required String languageCode,
}) {
  return switch (languageCode) {
    'es' || 'ca' => 'El jugador elige: "$choice". Continúa la historia con las consecuencias de esta decisión.',
    'fr' => 'Le joueur choisit: "$choice". Continuez l\'histoire.',
    _ => 'The player chooses: "$choice". Continue the story with the consequences of this decision.',
  };
}
