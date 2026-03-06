import 'package:get_it/get_it.dart';
import 'package:rol_genui/data/datasources/chat_datasource.dart';
import 'package:rol_genui/data/datasources/database_datasource.dart';
import 'package:rol_genui/data/repositories/character_repository_impl.dart';
import 'package:rol_genui/data/repositories/chat_repository_impl.dart';
import 'package:rol_genui/data/repositories/session_repository_impl.dart';
import 'package:rol_genui/domain/repositories/character_repository.dart';
import 'package:rol_genui/domain/repositories/chat_repository.dart';
import 'package:rol_genui/domain/repositories/session_repository.dart';
import 'package:rol_genui/domain/usecases/character_usecases/character_usecases.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/send_message_assistant_usecase.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/send_message_gemini_usecase.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/start_chat_assistant_usecases.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/start_chat_gemini_usecases.dart';
import 'package:rol_genui/domain/usecases/session_usecases/session_usecases.dart';
import 'package:rol_genui/presentation/blocs/character/character_bloc.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_bloc.dart';
import 'package:rol_genui/presentation/blocs/game/game_bloc.dart';
import 'package:rol_genui/presentation/blocs/language/language_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ── Database ────────────────────────────────────────────────────────────────
  final db = DatabaseDataSourceImpl();
  await db.init();
  sl.registerLazySingleton<DatabaseDataSource>(() => db);

  // ── Data sources ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl());
  sl.registerLazySingleton<GameRemoteDataSource>(() => GameRemoteDataSourceImpl());

  // ── Repositories ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerLazySingleton<CharacterRepository>(() => CharacterRepositoryImpl(sl()));
  sl.registerLazySingleton<SessionRepository>(() => SessionRepositoryImpl(sl()));

  // ── Chat use cases ──────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => StartChatGeminiUsecases(sl()));
  sl.registerLazySingleton(() => SendMessageGeminiUsecase(sl()));
  sl.registerLazySingleton(() => SendMessageAssistantUsecase(sl()));
  sl.registerLazySingleton(() => StartChatAssistantUsecases(sl()));

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
  sl.registerFactory<ChatBloc>(() => ChatBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory<CharacterBloc>(() => CharacterBloc(
    createCharacterUsecase: sl(),
    updateCharacterUsecase: sl(),
    deleteCharacterUsecase: sl(),
    getCharactersBySystemUsecase: sl(),
  ));
  sl.registerFactory<GameBloc>(() => GameBloc(
    startGameSessionUsecase: sl(),
    sendGameChoiceUsecase: sl(),
    loadSessionUsecase: sl(),
    generateSceneImageUsecase: sl(),
    updateCharacterUsecase: sl<UpdateCharacterUsecase>(),
  ));

  // ── Services ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
