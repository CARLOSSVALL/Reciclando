import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reciclando/nucleo/utils/app_logger.dart';
import 'package:reciclando/nucleo/config/api_config.dart';
import 'package:reciclando/servicios/network_service.dart';

/// Servicio de autenticación de Reciclando.
/// Se conecta al backend Node.js + MySQL.
class AuthService {
  static String? _token;
  static String? _userEmail;
  static String? _userName;
  static String? _userPhone;
  static int? _userId;

  static const _secureStorage = FlutterSecureStorage();
  static SharedPreferences? _prefs;

  /// Obtiene la instancia de SharedPreferences (cacheada) para datos no sensibles
  static Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Inicializa el servicio recuperando datos de almacenamiento seguro y SharedPreferences
  static Future<void> initialize() async {
    // SECURITY VALIDATION: Storing sensitive token in Secure Storage instead of SharedPreferences
    _token = await _secureStorage.read(key: 'authToken');

    final prefs = await _getPrefs();
    _userEmail = prefs.getString('userEmail');
    _userName = prefs.getString('userName');
    _userPhone = prefs.getString('userPhone');
    _userId = prefs.getInt('userId');

    if (_token != null) {
      AppLogger.info('Sesión restaurada para: $_userEmail', tag: 'AuthService');
    }
  }

  /// Login real contra el backend
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      if (!await NetworkService.isConnected()) {
        return {'success': false, 'message': 'No hay conexión a internet'};
      }

      if (email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Email y contraseña son obligatorios'
        };
      }

      // Check internet explicitly or catch it
      final response = await http
          .post(
            Uri.parse(ApiConfig.loginUrl),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            // SECURITY VALIDATION: No logging sensitive data like password
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final token = data['token'];
        final user = data['user'];
        await saveToken(token, user['email']);
        _userName = user['name'];
        _userPhone = user['phone'] ?? '';
        _userId = user['id'];

        final prefs = await _getPrefs();
        await prefs.setString('userName', _userName!);
        await prefs.setString('userPhone', _userPhone!);
        await prefs.setInt('userId', _userId!);

        AppLogger.info('Login exitoso: $email', tag: 'AuthService');
        return {'success': true, 'message': data['message'] ?? '¡Bienvenido!'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al iniciar sesión'
        };
      }
    } catch (e) {
      AppLogger.error('Error de conexión en login', tag: 'AuthService');
      return {
        'success': false,
        'message':
            'No se pudo conectar al servidor. Verifica tu conexión o que el backend esté encendido.'
      };
    }
  }

  /// Registro real contra el backend
  static Future<Map<String, dynamic>> register(
      String email, String password, String nombre,
      {String phone = ''}) async {
    try {
      if (email.isEmpty || password.isEmpty || nombre.isEmpty) {
        return {
          'success': false,
          'message': 'Todos los campos son obligatorios'
        };
      }

      final response = await http
          .post(
            Uri.parse(ApiConfig.registerUrl),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
              'name': nombre,
              'phone': phone,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        AppLogger.info('Registro exitoso: $email ($nombre)',
            tag: 'AuthService');
        return {
          'success': true,
          'message': data['message'] ?? '¡Cuenta creada con éxito!'
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al crear la cuenta'
        };
      }
    } catch (e) {
      AppLogger.error('Error de conexión en registro', tag: 'AuthService');
      return {'success': false, 'message': 'No se pudo conectar al servidor.'};
    }
  }

  /// Guarda el token de forma segura
  static Future<void> saveToken(String token, String email) async {
    _token = token;
    _userEmail = email;

    // Guardar token seguro
    await _secureStorage.write(key: 'authToken', value: token);

    final prefs = await _getPrefs();
    await prefs.setString('userEmail', email);
  }

  /// Obtener el token
  static String? getToken() => _token;

  /// Obtener el email del usuario
  static String? getUserEmail() => _userEmail;

  /// Obtener el nombre del usuario
  static String? getUserName() => _userName ?? _userEmail?.split('@')[0];

  /// Obtener el telefono del usuario
  static String? getUserPhone() => _userPhone;

  /// Obtener el ID del usuario
  static int? getUserId() => _userId;

  /// Verificar si hay una sesión activa
  static bool isLoggedIn() => _token != null && _token!.isNotEmpty;

  /// Actualiza el perfil de usuario (nombre y telefono)
  static Future<Map<String, dynamic>> updateProfile(String newName,
      {String phone = ''}) async {
    try {
      if (newName.isEmpty) {
        return {'success': false, 'message': 'El nombre no puede estar vacío'};
      }

      final response = await http
          .put(
            Uri.parse(ApiConfig.profileUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode({'name': newName, 'phone': phone}),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        _userName = newName;
        _userPhone = phone;
        final prefs = await _getPrefs();
        await prefs.setString('userName', newName);
        await prefs.setString('userPhone', phone);

        AppLogger.info('Perfil actualizado a: $newName', tag: 'AuthService');
        return {'success': true, 'message': 'Perfil actualizado correctamente'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al actualizar perfil'
        };
      }
    } catch (e) {
      AppLogger.error('Error actualizando perfil', tag: 'AuthService');
      return {'success': false, 'message': 'No se pudo conectar al servidor.'};
    }
  }

  /// Cambiar la contraseña
  static Future<Map<String, dynamic>> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      if (currentPassword.isEmpty || newPassword.isEmpty) {
        return {
          'success': false,
          'message': 'Ambas contraseñas son obligatorias'
        };
      }

      final response = await http
          .put(
            Uri.parse(ApiConfig.passwordUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode({
              'currentPassword': currentPassword,
              'newPassword': newPassword
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200 && data['success'] == true,
        'message': data['message'] ?? 'Error desconocido'
      };
    } catch (e) {
      AppLogger.error('Error actualizando contraseña', tag: 'AuthService');
      return {'success': false, 'message': 'No se pudo conectar al servidor.'};
    }
  }

  /// Eliminar cuenta
  static Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConfig.accountUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        await logout();
        return {'success': true, 'message': 'Cuenta eliminada'};
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Error al eliminar cuenta'
      };
    } catch (e) {
      AppLogger.error('Error eliminando cuenta', tag: 'AuthService');
      return {'success': false, 'message': 'No se pudo conectar al servidor.'};
    }
  }

  /// Cerrar sesión
  static Future<void> logout() async {
    _token = null;
    _userEmail = null;
    _userName = null;
    _userPhone = null;
    _userId = null;

    await _secureStorage.delete(key: 'authToken');

    final prefs = await _getPrefs();
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userPhone');
    await prefs.remove('userId');

    AppLogger.info('Sesión cerrada', tag: 'AuthService');
  }
}
