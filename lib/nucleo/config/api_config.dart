import 'package:reciclando/nucleo/config/env_config.dart';

/// Configuración de la API del backend.
class ApiConfig {
  /// URL base del backend Node.js (cargada desde .env)
  static String get baseUrl => EnvConfig.apiBaseUrl;

  /// Endpoints de autenticación
  static String get loginUrl => '$baseUrl/auth/login';
  static String get registerUrl => '$baseUrl/auth/register';
  static String get profileUrl => '$baseUrl/auth/profile';
  static String get passwordUrl => '$baseUrl/auth/password';
  static String get accountUrl => '$baseUrl/auth/account';

  /// Endpoints de marcadores
  static String get markersUrl => '$baseUrl/markers';
  static String markersByTypeUrl(String type) => '$baseUrl/markers/type/$type';
  static String get myMarkersUrl => '$baseUrl/markers/mine';
  static String donateUrl(String id) => '$baseUrl/markers/$id/donate';
  static String deleteMarkerUrl(String id) => '$baseUrl/markers/$id';
  static String collectMarkerUrl(String id) => '$baseUrl/markers/$id/collect';

  /// Endpoints de notificaciones
  static String get notificationsUrl => '$baseUrl/notifications';
  static String get unreadCountUrl => '$baseUrl/notifications/unread';
  static String readNotificationUrl(String id) => '$baseUrl/notifications/$id/read';
  static String get readAllNotificationsUrl => '$baseUrl/notifications/read-all';
}
