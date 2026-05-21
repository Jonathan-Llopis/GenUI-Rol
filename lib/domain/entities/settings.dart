import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.localModelPath,
    this.localModelName,
    this.hasSeenOnboarding = false,
  });

  final String? localModelPath;
  final String? localModelName;
  final bool hasSeenOnboarding;

  @override
  List<Object?> get props => [
        localModelPath,
        localModelName,
        hasSeenOnboarding,
      ];

  AppSettings copyWith({
    String? localModelPath,
    String? localModelName,
    bool? hasSeenOnboarding,
  }) {
    return AppSettings(
      localModelPath: localModelPath ?? this.localModelPath,
      localModelName: localModelName ?? this.localModelName,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}
