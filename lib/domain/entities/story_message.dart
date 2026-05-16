import 'dart:typed_data';
import 'package:rol_genui/domain/entities/combat.dart';
import 'package:rol_genui/domain/entities/inventory.dart';

enum MessageRole { narrator, player, system }

class StoryMessage {
  const StoryMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.text,
    required this.timestamp,
    this.imageBytes,
    this.choices,
    this.selectedChoiceIndex,
    this.characterUpdates,
    this.inventoryUpdates,
    this.combatState,
  });

  final String id;
  final String sessionId;
  final MessageRole role;
  final String text;
  final DateTime timestamp;
  final Uint8List? imageBytes;
  final List<String>? choices;
  final int? selectedChoiceIndex;
  final Map<String, int>? characterUpdates;
  final List<InventoryUpdate>? inventoryUpdates;
  final CombatState? combatState;

  StoryMessage copyWith({
    String? id,
    String? sessionId,
    MessageRole? role,
    String? text,
    DateTime? timestamp,
    Uint8List? imageBytes,
    List<String>? choices,
    int? selectedChoiceIndex,
    Map<String, int>? characterUpdates,
    List<InventoryUpdate>? inventoryUpdates,
    CombatState? combatState,
  }) {
    return StoryMessage(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      imageBytes: imageBytes ?? this.imageBytes,
      choices: choices ?? this.choices,
      selectedChoiceIndex: selectedChoiceIndex ?? this.selectedChoiceIndex,
      characterUpdates: characterUpdates ?? this.characterUpdates,
      inventoryUpdates: inventoryUpdates ?? this.inventoryUpdates,
      combatState: combatState ?? this.combatState,
    );
  }
}
