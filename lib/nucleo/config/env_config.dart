import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> initialize() async {
    // Si queremos condicionar por entorno, podríamos verificar kReleaseMode, etc.
    const isProd = bool.fromEnvironment('dart.vm.product');
    final envFile = isProd ? '.env' : '.env.dev';
    await dotenv.load(fileName: envFile);
  }

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
  static String get logLevel => dotenv.env['LOG_LEVEL'] ?? 'info';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
}
