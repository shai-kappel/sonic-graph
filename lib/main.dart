import 'package:flutter/material.dart';
import 'package:sonic_graph/app/di.dart';
import 'package:sonic_graph/core/config/app_config.dart';
import 'package:sonic_graph/core/theme/app_theme.dart';
import 'package:sonic_graph/features/canvas/presentation/pages/canvas_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.environment = Environment.dev;
  await initDependencies();
  runApp(const SonicGraphApp());
}

class SonicGraphApp extends StatelessWidget {
  const SonicGraphApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const CanvasPage(),
    );
  }
}
