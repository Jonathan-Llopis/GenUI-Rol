import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateLocalModel extends SettingsEvent {
  const UpdateLocalModel({this.path, this.name});
  final String? path;
  final String? name;
  @override
  List<Object?> get props => [path, name];
}

class UpdateOllamaUrl extends SettingsEvent {
  const UpdateOllamaUrl(this.url);
  final String url;
  @override
  List<Object?> get props => [url];
}

class CompleteOnboarding extends SettingsEvent {}
