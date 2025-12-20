import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rol_genui/config/router/routes.dart';
import 'package:rol_genui/injection.dart';
import 'package:rol_genui/l10n/l10n/app_localizations.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_bloc.dart';
import 'package:rol_genui/presentation/blocs/language/language_bloc.dart';
import 'package:rol_genui/presentation/blocs/language/language_event.dart';
import 'package:rol_genui/presentation/blocs/language/language_state.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// This is the main function of the app. It loads the environment variables
/// from the .env file, removes the splash screen after 2 seconds, initializes
/// Firebase, configures the dependencies, initializes the notification
/// service and runs the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  await configureDependencies();
  runApp(MyApp());
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
        BlocProvider(create: (_) => sl<LanguageBloc>()),
        BlocProvider(create: (_) => sl<ChatBloc>()),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          context.read<LanguageBloc>().add(GetLocaleEvent());
          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            title: 'Roll and Reserve',
            theme: ThemeData(primarySwatch: Colors.blue),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
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
