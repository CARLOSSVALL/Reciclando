import 'package:flutter/material.dart';
import 'package:reciclando/l10n/app_localizations.dart';

/// Enum que representa los tipos de objetos reciclables.
/// Cada tipo tiene un icono, color y nombre descriptivo.
enum MarkerType {
  ropa('Ropa', Icons.checkroom, Color(0xFF9C27B0)),
  vidrio('Vidrio', Icons.local_drink, Color(0xFF00BCD4)),
  papel('Papel', Icons.description, Color(0xFF2196F3)),
  juguetes('Juguetes', Icons.toys, Color(0xFFFF9800)),
  electronica('Electrónica', Icons.devices, Color(0xFF607D8B)),
  muebles('Muebles', Icons.chair, Color(0xFF795548)),
  alimentos('Alimentos', Icons.restaurant, Color(0xFFFF5722)),
  otros('Otros', Icons.category, Color(0xFF9E9E9E));

  final String label;
  final IconData icon;
  final Color color;
  const MarkerType(this.label, this.icon, this.color);

  /// Devuelve el nombre de la categoría traducido al idioma actual
  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case MarkerType.ropa:        return l10n.categoryClothing;
      case MarkerType.vidrio:      return l10n.categoryGlass;
      case MarkerType.papel:       return l10n.categoryPaper;
      case MarkerType.juguetes:    return l10n.categoryToys;
      case MarkerType.electronica: return l10n.categoryElectronics;
      case MarkerType.muebles:     return l10n.categoryFurniture;
      case MarkerType.alimentos:   return l10n.categoryFood;
      case MarkerType.otros:       return l10n.categoryOther;
    }
  }

  /// Obtener MarkerType desde string (para JSON)
  static MarkerType fromString(String value) {
    return MarkerType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MarkerType.otros,
    );
  }
}

/// Modelo de marcador de reciclaje.
/// Representa un punto en el mapa donde alguien ha dejado un objeto para reciclar/donar.
class RecycleMarker {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final MarkerType type;
  final String description;
  final String photoUrl;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  const RecycleMarker({
    required this.id,
    required this.userId,
    required this.userName,
    this.userEmail = '',
    this.userPhone = '',
    required this.type,
    required this.description,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  /// Constructor desde JSON (respuesta del backend)
  factory RecycleMarker.fromJson(Map<String, dynamic> json) {
    return RecycleMarker(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Anónimo',
      userEmail: json['userEmail'] ?? '',
      userPhone: json['userPhone'] ?? '',
      type: MarkerType.fromString(json['type'] ?? 'otros'),
      description: json['description'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convertir a JSON (para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'type': type.name,
      'description': description,
      'photoUrl': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Crea una copia del marcador con campos modificados
  RecycleMarker copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhone,
    MarkerType? type,
    String? description,
    String? photoUrl,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
  }) {
    return RecycleMarker(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      type: type ?? this.type,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
