
import 'package:get_it/get_it.dart';
import 'package:rol_genui/data/datasources/chat_datasource.dart';
import 'package:rol_genui/data/repositories/chat_repository_impl.dart';
import 'package:rol_genui/domain/repositories/chat_repository.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/send_message_assistant_usecase.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/send_message_gemini_usecase.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/start_chat_assistant_usecases.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/start_chat_gemini_usecases.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_bloc.dart';
import 'package:rol_genui/presentation/blocs/language/language_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

/// Configures the dependencies of the application.
///
/// This function registers all the necessary dependencies with
/// [GetIt.instance], such as the repositories, use cases, and data sources.
/// It also sets up the BLoCs and the underlying services.
///
/// This function is called when the application starts.
///
void configureDependencies() async {
  // BLocs

  sl.registerFactory<LanguageBloc>(() => LanguageBloc(sl()));
  sl.registerFactory<ChatBloc>(
      () => ChatBloc(sl(), sl(), sl(), sl()));
  // Instancia de Firebase Auth
 
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(),
  );
  // Repositorios

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<StartChatGeminiUsecases>(
    () => StartChatGeminiUsecases(sl()),
  );
  sl.registerLazySingleton<SendMessageGeminiUsecase>(
    () => SendMessageGeminiUsecase(sl()),
  );
  sl.registerLazySingleton<SendMessageAssistantUsecase>(
    () => SendMessageAssistantUsecase(sl()),
  );
  sl.registerLazySingleton<StartChatAssistantUsecases>(
    () => StartChatAssistantUsecases(sl()),
  );

  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
