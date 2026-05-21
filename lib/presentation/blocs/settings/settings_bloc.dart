import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rol_genui/domain/entities/settings.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_event.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._prefs) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateLocalModel>(_onUpdateLocalModel);
    on<CompleteOnboarding>(_onCompleteOnboarding);
  }

  final SharedPreferences _prefs;

  static const _keyLocalModelPath = 'local_model_path';
  static const _keyLocalModelName = 'local_model_name';
  static const _keyHasSeenOnboarding = 'has_seen_onboarding';

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final localPath = _prefs.getString(_keyLocalModelPath);
      final localName = _prefs.getString(_keyLocalModelName);
      final hasSeenOnboarding = _prefs.getBool(_keyHasSeenOnboarding) ?? false;

      final settings = AppSettings(
        localModelPath: localPath,
        localModelName: localName,
        hasSeenOnboarding: hasSeenOnboarding,
      );
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(const SettingsError('Error cargando ajustes'));
    }
  }

  Future<void> _onUpdateLocalModel(UpdateLocalModel event, Emitter<SettingsState> emit) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      if (event.path != null) await _prefs.setString(_keyLocalModelPath, event.path!);
      if (event.name != null) await _prefs.setString(_keyLocalModelName, event.name!);
      emit(SettingsLoaded(currentState.settings.copyWith(
        localModelPath: event.path,
        localModelName: event.name,
      )));
    }
  }

  Future<void> _onCompleteOnboarding(CompleteOnboarding event, Emitter<SettingsState> emit) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      await _prefs.setBool(_keyHasSeenOnboarding, true);
      emit(SettingsLoaded(currentState.settings.copyWith(hasSeenOnboarding: true)));
    }
  }
}
