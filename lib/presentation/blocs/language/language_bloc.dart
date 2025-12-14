import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rol_genui/presentation/blocs/language/language_event.dart';
import 'package:rol_genui/presentation/blocs/language/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences sharedPreferences;

  LanguageBloc(this.sharedPreferences) : super(LanguageState(Locale('es'))) {
    on<ChangeLanguageEvent>((event, emit) async {
      await sharedPreferences.setString('locale', '${event.locale.languageCode}_${event.locale.countryCode}');
      emit(LanguageState(event.locale));
    });

    on<GetLocaleEvent>((event, emit) async {
      final localeString = sharedPreferences.getString('locale');
      if (localeString != null) {
        final parts = localeString.split('_');
        emit(LanguageState(Locale(parts[0], parts[1])));
      } else {
        emit(LanguageState(Locale('es')));
      }
    });
  }
}