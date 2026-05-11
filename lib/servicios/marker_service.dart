import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:reciclando/modelos/marker_model.dart';
import 'package:reciclando/Implementaciones/auth/data/services/auth_service.dart';
import 'package:reciclando/nucleo/utils/app_logger.dart';
import 'package:reciclando/nucleo/config/api_config.dart';

/// Servicio de marcadores que se conecta al backend Node.js + MySQL.
class MarkerService {
  /// Timeout estándar para peticiones HTTP
  static const _timeout = Duration(seconds: 15);

  /// Headers con autenticación JWT + bypass ngrok warning
  static Map<String, String> _authHeaders() => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.getToken()}',
        'ngrok-skip-browser-warning': 'true',
      };

  /// Headers públicos (sin auth) + bypass ngrok warning
  static Map<String, String> _publicHeaders() => {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };

  /// Obtiene todos los marcadores (con filtro por radio opcional)
  static Future<List<RecycleMarker>> getMarkers({double? lat, double? lng}) async {
    try {
      String url = ApiConfig.markersUrl;
      if (lat != null && lng != null) {
        url += '?lat=$lat&lng=$lng&radius=100';
      }
      final response = await http.get(
        Uri.parse(url),
        headers: _publicHeaders(),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // Soporta tanto array directo como objeto de paginación {data: [...]}
        final List<dynamic> data = decoded is Map<String, dynamic> && decoded.containsKey('data') 
            ? decoded['data'] 
            : decoded;
            
        final markers = data.map((json) => RecycleMarker.fromJson(json)).toList();
        AppLogger.debug('GET markers: ${markers.length}', tag: 'MarkerService');
        return markers;
      }
      AppLogger.error('Error GET markers: ${response.statusCode}', tag: 'MarkerService');
      return [];
    } catch (e) {
      AppLogger.error('Error de conexión obteniendo marcadores', tag: 'MarkerService', error: e);
      return [];
    }
  }

  /// Obtiene marcadores filtrados por tipo (con filtro por radio opcional)
  static Future<List<RecycleMarker>> getMarkersByType(MarkerType type, {double? lat, double? lng}) async {
    try {
      String url = ApiConfig.markersByTypeUrl(type.name);
      if (lat != null && lng != null) {
        url += '?lat=$lat&lng=$lng&radius=100';
      }
      final response = await http.get(
        Uri.parse(url),
        headers: _publicHeaders(),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RecycleMarker.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      AppLogger.error('Error filtrando marcadores', tag: 'MarkerService', error: e);
      return [];
    }
  }

  /// Obtiene los marcadores creados por el usuario actual
  static Future<List<RecycleMarker>> getMyMarkers() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.myMarkersUrl),
        headers: _authHeaders(),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RecycleMarker.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      AppLogger.error('Error obteniendo mis marcadores', tag: 'MarkerService', error: e);
      return [];
    }
  }

  /// Crea un nuevo marcador CON subida de imagen real al servidor
  static Future<RecycleMarker?> createMarker({
    required MarkerType type,
    required String description,
    required double latitude,
    required double longitude,
    required XFile photoXFile,
    void Function(double progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0.1);

      // Crear petición multipart para subir la foto
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.markersUrl),
      );

      // Añadir headers de autenticación + ngrok bypass
      request.headers['Authorization'] = 'Bearer ${AuthService.getToken()}';
      request.headers['ngrok-skip-browser-warning'] = 'true';

      // Añadir campos de texto
      request.fields['type'] = type.name;
      request.fields['description'] = description;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();

      onProgress?.call(0.3);

      // Añadir la foto como archivo (funciona en Web y móvil guardando sus bytes)
      final bytes = await photoXFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('photo', bytes, filename: photoXFile.name),
      );

      onProgress?.call(0.6);

      // Enviar la petición
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      onProgress?.call(1.0);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        AppLogger.info('Marcador creado con foto: ${data['id']}', tag: 'MarkerService');
        return RecycleMarker.fromJson(data);
      }
      AppLogger.error('Error creando marcador: ${response.statusCode} - ${response.body}', tag: 'MarkerService');
      return null;
    } catch (e) {
      AppLogger.error('Error de conexión creando marcador', tag: 'MarkerService', error: e);
      return null;
    }
  }

  /// Incrementa donaciones de un marcador
  static Future<bool> donateMarker(String markerId) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.donateUrl(markerId)),
        headers: _publicHeaders(),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        AppLogger.info('Donación registrada para marcador: $markerId', tag: 'MarkerService');
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('Error en donación', tag: 'MarkerService', error: e);
      return false;
    }
  }

  /// Elimina un marcador (solo el dueño)
  static Future<bool> deleteMarker(String markerId) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConfig.deleteMarkerUrl(markerId)),
        headers: _authHeaders(),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        AppLogger.info('Marcador eliminado: $markerId', tag: 'MarkerService');
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('Error eliminando marcador', tag: 'MarkerService', error: e);
      return false;
    }
  }

  /// Recoge un objeto: elimina el marcador y notifica al dueño
  static Future<Map<String, dynamic>> collectMarker(String markerId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.collectMarkerUrl(markerId)),
        headers: _authHeaders(),
      ).timeout(_timeout);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        AppLogger.info('Objeto recogido: $markerId', tag: 'MarkerService');
        return {
          'success': true,
          'ownerName': data['ownerName'] ?? 'Usuario',
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Error al recoger el objeto',
      };
    } catch (e) {
      AppLogger.error('Error recogiendo objeto', tag: 'MarkerService', error: e);
      return {'success': false, 'message': 'No se pudo conectar al servidor.'};
    }
  }
}
