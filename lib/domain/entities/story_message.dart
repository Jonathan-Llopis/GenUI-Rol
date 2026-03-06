import 'dart:typed_data';

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
    );
  }
}
