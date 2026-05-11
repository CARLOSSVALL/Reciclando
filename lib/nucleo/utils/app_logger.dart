import 'package:logger/logger.dart';
import 'package:reciclando/nucleo/config/env_config.dart';

/// Logger centralizado para Reciclando.
/// Selecciona el filtro automáticamente según LOG_LEVEL del entorno:
/// - 'debug' → DevelopmentFilter (muestra todo)
/// - 'info' / cualquier otro → ProductionFilter (solo warning y error)
class AppLogger {
  static const String _defaultTag = 'Reciclando';
  static Logger? _logger;

  /// Construye la configuración de impresión compartida
  static PrettyPrinter _buildPrinter() => PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      );

  /// Selecciona el filtro según LOG_LEVEL del .env
  static LogFilter _buildFilter() {
    final level = EnvConfig.logLevel.toLowerCase();
    return level == 'debug' ? DevelopmentFilter() : ProductionFilter();
  }

  /// Inicializa el logger respetando el entorno
  static Future<void> init() async {
    _logger ??= Logger(
      filter: _buildFilter(),
      printer: _buildPrinter(),
      output: ConsoleOutput(),
    );
  }

  /// Obtiene el logger, inicializándolo si es necesario
  static Logger get _log {
    _logger ??= Logger(
      filter: _buildFilter(),
      printer: _buildPrinter(),
      output: ConsoleOutput(),
    );
    return _logger!;
  }

  static void debug(String message, {String? tag}) =>
      _log.d('[${tag ?? _defaultTag}] $message');

  static void info(String message, {String? tag}) =>
      _log.i('[${tag ?? _defaultTag}] $message');

  static void warning(String message, {String? tag, Object? error}) =>
      _log.w('[${tag ?? _defaultTag}] $message', error: error);

  static void error(String message,
          {String? tag, Object? error, StackTrace? stackTrace}) =>
      _log.e('[${tag ?? _defaultTag}] $message',
          error: error, stackTrace: stackTrace);

  static void network(String message, {String? tag}) =>
      _log.t('[${tag ?? _defaultTag}] [NETWORK] $message');
}
