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

class CompleteOnboarding extends SettingsEvent {}
