import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reciclando/l10n/app_localizations.dart';
import 'package:reciclando/nucleo/theme/Modos/Temas/theme_manager.dart';
import 'package:reciclando/nucleo/utils/app_logger.dart';
import 'package:reciclando/nucleo/config/env_config.dart';
import 'package:reciclando/Implementaciones/auth/data/services/auth_service.dart';
import 'package:reciclando/pantallas/home_screen.dart';
import 'package:reciclando/Implementaciones/auth/presentacion/pages/inicio.dart';
import 'package:reciclando/servicios/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar entorno (cargas de .env / .env.dev)
  await EnvConfig.initialize();

  // Inicializar Logger PRIMERO para que los demás servicios puedan usarlo
  await AppLogger.init();

  AppLogger.info('═══════════════════════════════════════', tag: 'Main');
  AppLogger.info('RECICLANDO - Iniciando app en entorno: ${EnvConfig.environment}', tag: 'Main');
  AppLogger.info('═══════════════════════════════════════', tag: 'Main');

  // Cargar tema desde SharedPreferences
  await ThemeManager().loadInitialTheme();

  // Inicializar Auth (recuperar sesión si existe)
  await AuthService.initialize();

  // Inicializar notificaciones
  await NotificationService.initialize();

  // Optimizaciones de caché de imágenes
  if (!kIsWeb) {
    PaintingBinding.instance.imageCache.maximumSize = 50;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50 MB límite caché
  }

  runApp(const ReciclandoApp());
}

/// App principal de Reciclando
class ReciclandoApp extends StatelessWidget {
  const ReciclandoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager(),
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: EnvConfig.environment == 'development',
          title: 'Reciclando',
          theme: ThemeManager().currentTheme,
          // LOCALIZATION SETUP
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es'), // Español
            Locale('en'), // Inglés
          ],
          home: AuthService.isLoggedIn() ? const HomeScreen() : const Inicio(),
        );
      },
    );
  }
}
