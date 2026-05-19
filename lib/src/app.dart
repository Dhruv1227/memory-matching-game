import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'models/game_models.dart';
part 'screens/memory_game_page.dart';
part 'screens/start_screen.dart';
part 'widgets/game_header.dart';
part 'widgets/game_cards.dart';
part 'widgets/game_dialogs.dart';
part 'widgets/confetti_painter.dart';

class MemoryMatchApp extends StatelessWidget {
  const MemoryMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF172C2A);
    const sea = Color(0xFF0F6B5B);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Match',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: sea,
          primary: sea,
          secondary: const Color(0xFFE96B56),
          tertiary: const Color(0xFFF0B84C),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F1E8),
        useMaterial3: true,
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: ink,
          displayColor: ink,
        ),
      ),
      home: const MemoryGamePage(),
    );
  }
}
