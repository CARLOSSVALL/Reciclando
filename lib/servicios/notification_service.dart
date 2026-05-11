import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reciclando/Implementaciones/auth/data/services/auth_service.dart';
import 'package:reciclando/nucleo/config/api_config.dart';
import 'package:reciclando/nucleo/utils/app_logger.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await AuthService.initialize();
      
      final currentUnreadCount = await NotificationService.getUnreadCount();
      
      final prefs = await SharedPreferences.getInstance();
      final lastCount = prefs.getInt('last_unread_count') ?? 0;
      
      if (currentUnreadCount > lastCount) {
        final notifications = await NotificationService.getNotifications();
        if (notifications.isNotEmpty) {
           final latest = notifications.first;
           await NotificationService.showSystemNotification(latest);
        }
      }
      
      await prefs.setInt('last_unread_count', currentUnreadCount);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

/// Modelo de notificación
class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

/// Servicio de notificaciones que se conecta al backend.
class NotificationService {
  /// Timeout estándar para peticiones HTTP
  static const _timeout = Duration(seconds: 15);

  /// Headers con autenticación JWT + bypass ngrok warning
  static Map<String, String> _authHeaders() => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.getToken()}',
        'ngrok-skip-browser-warning': 'true',
      };

  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  /// Inicialización de WorkManager y notificaciones nativas
  static Future<void> initialize() async {
    // Configurar notificaciones locales
    const AndroidInitializationSettings initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: initSettingsAndroid);
    await _localNotifications.initialize(settings: initSettings);

    // Configurar Tarea de background (solo en móviles)
    if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
      await Workmanager().initialize(
        callbackDispatcher,
      );

      // Mínimo 15 minutos (Regla de Android para ahorro estricto de batería)
      await Workmanager().registerPeriodicTask(
        "1",
        "fetch_notifications_task",
        frequency: const Duration(minutes: 15),
      );
    }

    AppLogger.info('NotificationService inicializado nativo (Local + Workmanager)', tag: 'NotificationService');
  }

  /// Mostrar la notificación en la barra de tareas de Android
  static Future<void> showSystemNotification(AppNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'reciclando_channel_id', 'Notificaciones de Reciclando',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            icon: '@mipmap/ic_launcher');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      id: notification.id.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: platformChannelSpecifics,
    );
  }

  /// Obtener todas las notificaciones del usuario
  static Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.notificationsUrl),
        headers: _authHeaders(),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AppNotification.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      AppLogger.error('Error obteniendo notificaciones', tag: 'NotificationService', error: e);
      return [];
    }
  }

  /// Obtener número de notificaciones sin leer
  static Future<int> getUnreadCount() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.unreadCountUrl),
        headers: _authHeaders(),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['count'] ?? 0;
      }
      return 0;
    } catch (e) {
      AppLogger.error('Error contando notificaciones', tag: 'NotificationService', error: e);
      return 0;
    }
  }

  /// Marcar una notificación como leída
  static Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.readNotificationUrl(notificationId)),
        headers: _authHeaders(),
      ).timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.error('Error marcando notificación', tag: 'NotificationService', error: e);
      return false;
    }
  }

  /// Marcar todas las notificaciones como leídas
  static Future<bool> markAllAsRead() async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.readAllNotificationsUrl),
        headers: _authHeaders(),
      ).timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.error('Error marcando todas las notificaciones', tag: 'NotificationService', error: e);
      return false;
    }
  }
}
