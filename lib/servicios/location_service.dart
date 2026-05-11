import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:reciclando/nucleo/utils/app_logger.dart';

/// Servicio de ubicación para Reciclando.
/// Gestiona permisos, posición actual y stream de ubicación.
class LocationService {
  /// Solicita permisos de ubicación al usuario
  static Future<bool> requestPermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppLogger.warning('Servicios de ubicación desactivados',
          tag: 'LocationService');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppLogger.warning('Permiso de ubicación denegado',
            tag: 'LocationService');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppLogger.error('Permiso de ubicación denegado permanentemente',
          tag: 'LocationService');
      return false;
    }

    AppLogger.info('Permiso de ubicación concedido', tag: 'LocationService');
    return true;
  }

  /// Obtiene la posición actual del dispositivo
  static Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      AppLogger.debug(
        'Posición actual: ${position.latitude}, ${position.longitude}',
        tag: 'LocationService',
      );
      return position;
    } catch (e) {
      AppLogger.error('Error obteniendo posición',
          tag: 'LocationService', error: e);
      return null;
    }
  }

  /// Stream de posición del dispositivo (actualizaciones continuas)
  static Stream<Position> getPositionStream({
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    );
  }

  /// Calcula la distancia entre dos puntos en metros
  static double getDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
