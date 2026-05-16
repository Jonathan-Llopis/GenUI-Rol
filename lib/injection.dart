import 'package:get_it/get_it.dart';
import 'package:rol_genui/data/datasources/chat_datasource.dart';
import 'package:rol_genui/data/datasources/database_datasource.dart';
import 'package:rol_genui/data/repositories/character_repository_impl.dart';
import 'package:rol_genui/data/repositories/session_repository_impl.dart';
import 'package:rol_genui/domain/repositories/character_repository.dart';
import 'package:rol_genui/domain/repositories/session_repository.dart';
import 'package:rol_genui/domain/usecases/character_usecases/character_usecases.dart';
import 'package:rol_genui/domain/usecases/session_usecases/session_usecases.dart';
import 'package:rol_genui/presentation/blocs/character/character_bloc.dart';
import 'package:rol_genui/presentation/blocs/game/game_bloc.dart';
import 'package:rol_genui/presentation/blocs/language/language_bloc.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:rol_genui/core/services/model_downloader.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ── SharedPreferences ───────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ── Database ────────────────────────────────────────────────────────────────
  final db = DatabaseDataSourceImpl();
  await db.init();
  sl.registerLazySingleton<DatabaseDataSource>(() => db);

  // ── Data sources ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<GameRemoteDataSource>(
    () => LocalGameDataSourceImpl(
      modelPathProvider: () => sl<SharedPreferences>().getString('local_model_path'),
    ),
  );

  // ── Repositories ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(sl()),
  );

  // ── Character use cases ─────────────────────────────────────────────────────
  sl.registerLazySingleton(() => CreateCharacterUsecase(sl()));
  sl.registerLazySingleton(() => UpdateCharacterUsecase(sl()));
  sl.registerLazySingleton(() => DeleteCharacterUsecase(sl()));
  sl.registerLazySingleton(() => GetCharacterUsecase(sl()));
  sl.registerLazySingleton(() => GetCharactersBySystemUsecase(sl()));

  // ── Session use cases ───────────────────────────────────────────────────────
  sl.registerLazySingleton(() => StartGameSessionUsecase(sl(), sl()));
  sl.registerLazySingleton(() => SendGameChoiceUsecase(sl(), sl()));
  sl.registerLazySingleton(() => LoadSessionUsecase(sl()));
  sl.registerLazySingleton(() => GetSessionsForCharacterUsecase(sl()));
  sl.registerLazySingleton(() => DeleteSessionUsecase(sl()));
  sl.registerLazySingleton(() => GenerateSceneImageUsecase(sl()));

  // ── BLoCs ───────────────────────────────────────────────────────────────────
  sl.registerFactory<LanguageBloc>(() => LanguageBloc(sl()));
  sl.registerFactory<SettingsBloc>(() => SettingsBloc(sl()));
  sl.registerFactory<CharacterBloc>(
    () => CharacterBloc(
      createCharacterUsecase: sl(),
      updateCharacterUsecase: sl(),
      deleteCharacterUsecase: sl(),
      getCharactersBySystemUsecase: sl(),
    ),
  );
  sl.registerFactory<GameBloc>(
    () => GameBloc(
      startGameSessionUsecase: sl(),
      sendGameChoiceUsecase: sl(),
      loadSessionUsecase: sl(),
      generateSceneImageUsecase: sl(),
      updateCharacterUsecase: sl<UpdateCharacterUsecase>(),
    ),
  );

  // ── Services ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => ModelDownloader(sl()));
}
