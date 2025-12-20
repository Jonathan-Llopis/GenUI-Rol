import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rol_genui/main.dart';
import 'package:rol_genui/presentation/screens/home/screen_home.dart';
import 'package:rol_genui/presentation/widgets/default_app_bar.dart';

PreferredSizeWidget appBar = DefaultAppBar();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const Scaffold(
        appBar: DefaultAppBar(),
        body: ScreenHome(),
      ),
    ),
  ],
);
