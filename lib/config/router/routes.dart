import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rol_genui/main.dart';
import 'package:rol_genui/presentation/widgets/default_app_bar.dart';

PreferredSizeWidget appBar = DefaultAppBar();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/user',
  routes: [
   
    
  ],

);
