import 'package:flutter/material.dart';
import 'backend/g_log.dart';
import 'frontend/home_page.dart';
import 'frontend/set_limit_page.dart';
import 'frontend/permission_page.dart';

void main() {
  GLog.i('Main', '🚀 G COUNT App Starting...');
  runApp(const GCountApp());
}

class GCountApp extends StatelessWidget {
  const GCountApp({super.key});

  @override
  Widget build(BuildContext context) {
    GLog.i('Main', 'App widget built');
    return MaterialApp(
      title: 'G COUNT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1B2A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2979FF),
          surface: Color(0xFF0D1B2A),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/set-limit': (context) => const SetLimitPage(),
        '/permission': (context) => const PermissionPage(),
      },
    );
  }
}