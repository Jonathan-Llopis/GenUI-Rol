import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rol_genui/config/router/routes.dart';
import 'package:rol_genui/core/logging/app_logger.dart';
import 'package:rol_genui/injection.dart';
import 'package:rol_genui/l10n/l10n/app_localizations.dart';
import 'package:rol_genui/data/repositories/rule_repository.dart';
import 'package:rol_genui/presentation/blocs/language/language_bloc.dart';
import 'package:rol_genui/presentation/blocs/language/language_event.dart';
import 'package:rol_genui/presentation/blocs/language/language_state.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_bloc.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_event.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final _log = getLogger('Main');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  _log.info('Iniciando Rol GenUI...');

  await dotenv.load(fileName: ".env");
  _log.config('Variables de entorno cargadas');

  await configureDependencies();
  await sl<RuleRepository>().init();
  _log.info('Dependencias configuradas y reglas cargadas');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LanguageBloc>()..add(GetLocaleEvent())),
        BlocProvider(create: (_) => sl<SettingsBloc>()..add(LoadSettings())),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            title: 'Rol GenUI',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF6B2D8B),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('fr'),
              Locale('ca'),
            ],
            locale: state.locale,
          );
        },
      ),
    );
  }
}
