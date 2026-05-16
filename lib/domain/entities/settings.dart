import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.localModelPath,
    this.localModelName,
    this.ollamaUrl = 'http://localhost:11434',
    this.hasSeenOnboarding = false,
  });

  final String? localModelPath;
  final String? localModelName;
  final String ollamaUrl;
  final bool hasSeenOnboarding;

  @override
  List<Object?> get props => [
        localModelPath,
        localModelName,
        ollamaUrl,
        hasSeenOnboarding,
      ];

  AppSettings copyWith({
    String? localModelPath,
    String? localModelName,
    String? ollamaUrl,
    bool? hasSeenOnboarding,
  }) {
    return AppSettings(
      localModelPath: localModelPath ?? this.localModelPath,
      localModelName: localModelName ?? this.localModelName,
      ollamaUrl: ollamaUrl ?? this.ollamaUrl,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}
