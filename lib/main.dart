import 'package:chatapp_ui/src/di.dart';
import 'package:chatapp_ui/src/presentation/common/ui_colors.dart';
import 'package:chatapp_ui/src/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouteManager.router,
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: UIColors.primary).copyWith(
          primary: UIColors.primary,
          surface: UIColors.primarySurface,
          primaryContainer: UIColors.primaryContainer,
          onPrimaryContainer: UIColors.onPrimaryContainer,
          secondary: UIColors.secondarySurface,
          background: UIColors.background,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
    );
  }
}
