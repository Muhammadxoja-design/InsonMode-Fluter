
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insonmode_fluter/core/theme/app_theme.dart';
import 'package:insonmode_fluter/features/auth/presentation/login_screen.dart';
import 'package:insonmode_fluter/features/home/presentation/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: InsonModeApp()));
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

class InsonModeApp extends StatelessWidget {
  const InsonModeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'InsonMode',
      theme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
