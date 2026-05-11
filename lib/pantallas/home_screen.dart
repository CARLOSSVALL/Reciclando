import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reciclando/modelos/marker_model.dart';
import 'package:reciclando/servicios/marker_service.dart';
import 'package:reciclando/servicios/location_service.dart';
import 'package:reciclando/servicios/notification_service.dart';
import 'package:reciclando/pantallas/create_marker_screen.dart';
import 'package:reciclando/pantallas/marker_detail_screen.dart';
import 'package:reciclando/componentes/bottom_sheet_marker.dart';
import 'package:reciclando/Implementaciones/auth/data/services/auth_service.dart';
import 'package:reciclando/Implementaciones/auth/presentacion/pages/inicio.dart';
import 'package:reciclando/nucleo/theme/Modos/Temas/theme_manager.dart';
import 'package:reciclando/nucleo/utils/app_logger.dart';
import 'package:reciclando/pantallas/profile_screen.dart';
import 'package:reciclando/pantallas/my_publications_screen.dart';
import 'package:reciclando/pantallas/marker_list_screen.dart';
import 'package:reciclando/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pantalla principal con Google Maps y marcadores de reciclaje.
/// Muestra en tiempo real los marcadores de todos los usuarios.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoading = true;
  MarkerType? _selectedFilter;
  Timer? _refreshTimer;
  int _lastNotificationCount = 0;

  // Animación del FAB
  late AnimationController _fabAnimController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimController, curve: Curves.elasticOut),
    );
    _initLocation();
    _loadInitialNotificationCount();

    // Refrescar marcadores y comprobar notificaciones cada 30 segundos
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        _loadMarkers();
        _checkAndShowNotifications();
      },
    );
  }

  /// Carga el último conteo guardado para no re-notificar al abrir la app
  Future<void> _loadInitialNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    _lastNotificationCount = prefs.getInt('last_unread_count') ?? 0;
  }

  /// Comprueba si hay nuevas notificaciones y las muestra como notificación del sistema
  Future<void> _checkAndShowNotifications() async {
    try {
      final count = await NotificationService.getUnreadCount();
      if (count > _lastNotificationCount) {
        final notifications = await NotificationService.getNotifications();
        // Mostrar solo las nuevas
        for (int i = 0; i < (count - _lastNotificationCount) && i < notifications.length; i++) {
          await NotificationService.showSystemNotification(notifications[i]);
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('last_unread_count', count);
        _lastNotificationCount = count;
      }
    } catch (e) {
      AppLogger.error('Error comprobando notificaciones', tag: 'HomeScreen', error: e);
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _refreshTimer?.cancel();
    _fabAnimController.dispose();
    super.dispose();
  }

  /// Inicializa la ubicación y carga los marcadores
  Future<void> _initLocation() async {
    final position = await LocationService.getCurrentPosition();
    if (position != null && mounted) {
      setState(() => _currentPosition = position);
    } else if (mounted) {
      _showLocationDialog();
    }
    await _loadMarkers();
    _fabAnimController.forward();
  }

  void _showLocationDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.locationRequiredTitle),
        content: Text(l10n.locationRequiredBody),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.locationLater),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
              // Reintentar tras un breve retraso
              Future.delayed(const Duration(seconds: 2), _initLocation);
            },
            child: Text(l10n.locationGoToSettings),
          ),
        ],
      ),
    );
  }

  /// Carga marcadores del backend
  Future<void> _loadMarkers() async {
    try {
      List<RecycleMarker> markers;
      final lat = _currentPosition?.latitude;
      final lng = _currentPosition?.longitude;

      if (_selectedFilter != null) {
        markers = await MarkerService.getMarkersByType(_selectedFilter!, lat: lat, lng: lng);
      } else {
        markers = await MarkerService.getMarkers(lat: lat, lng: lng);
      }

      if (mounted) {
        setState(() {
          _markers = _buildGoogleMarkers(markers);
          _isLoading = false;
        });
      }
    } catch (e) {
      AppLogger.error('Error cargando marcadores', tag: 'HomeScreen', error: e);
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Convierte RecycleMarker a Google Maps Marker con colores por tipo
  Set<Marker> _buildGoogleMarkers(List<RecycleMarker> markers) {
    return markers.map((m) {
      return Marker(
        markerId: MarkerId(m.id),
        position: LatLng(m.latitude, m.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(m.type)),
        onTap: () => _showMarkerBottomSheet(m),
      );
    }).toSet();
  }

  /// Color del marcador según tipo de objeto
  double _getMarkerHue(MarkerType type) => switch (type) {
        MarkerType.ropa => BitmapDescriptor.hueViolet,
        MarkerType.vidrio => BitmapDescriptor.hueCyan,
        MarkerType.papel => BitmapDescriptor.hueBlue,
        MarkerType.juguetes => BitmapDescriptor.hueOrange,
        MarkerType.electronica => BitmapDescriptor.hueRose,
        MarkerType.muebles => BitmapDescriptor.hueYellow,
        MarkerType.alimentos => BitmapDescriptor.hueRed,
        MarkerType.otros => BitmapDescriptor.hueGreen,
      };

  /// Muestra bottom sheet con detalles del marcador
  void _showMarkerBottomSheet(RecycleMarker marker) {
    bool canCollect = false;
    if (_currentPosition != null) {
      final distance = LocationService.getDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        marker.latitude,
        marker.longitude,
      );
      if (distance <= 1000) {
        canCollect = true;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BottomSheetMarker(
        marker: marker,
        onViewDetails: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MarkerDetailScreen(marker: marker),
            ),
          ).then((_) => _loadMarkers());
        },
        onCollect: canCollect ? () async {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final l10n = AppLocalizations.of(context)!;
          Navigator.pop(context); // Cerrar el bottom sheet

          final result = await MarkerService.collectMarker(marker.id);
          if (result['success'] == true) {
            _loadMarkers();
            if (mounted) {
              final String ownerName = result['ownerName']?.toString() ?? 'Usuario';
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(l10n.collectedSuccess(ownerName)),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          } else {
            if (mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(result['message'] ?? l10n.collectError),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } : null,
      ),
    );
  }

  /// Navega a crear marcador y recarga al volver
  Future<void> _navigateToCreateMarker() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.waitingLocation),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateMarkerScreen(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
        ),
      ),
    );

    if (result == true) {
      _loadMarkers();
    }
  }

  /// Cierra sesión
  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Inicio()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final initialPosition = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : const LatLng(39.4699, -0.3763); // Valencia por defecto

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.recycling, size: 28),
            const SizedBox(width: 8),
            Text(l10n.homeTitle),
          ],
        ),
        actions: const [],
      ),
      body: Stack(
        children: [
          // Mapa
          _isLoading && _currentPosition == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(l10n.loadingMap),
                    ],
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialPosition,
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  markers: _markers,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  mapToolbarEnabled: false,
                ),

          // Chips de filtro (parte superior)
          Positioned(
            top: 8,
            left: 8,
            right: 60, // Dejamos espacio para el botón de menú
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Chip "Todos"
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(l10n.filterAll),
                      selected: _selectedFilter == null,
                      onSelected: (selected) {
                        setState(() => _selectedFilter = null);
                        _loadMarkers();
                      },
                      avatar: const Icon(Icons.all_inclusive, size: 18),
                      selectedColor:
                          theme.colorScheme.primary.withValues(alpha: 0.3),
                      checkmarkColor: theme.colorScheme.primary,
                    ),
                  ),
                  // Chips por tipo
                  ...MarkerType.values.map((type) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(type.label),
                          selected: _selectedFilter == type,
                          onSelected: (selected) {
                            setState(
                                () => _selectedFilter = selected ? type : null);
                            _loadMarkers();
                          },
                          avatar: Icon(type.icon, size: 18, color: type.color),
                          selectedColor: type.color.withValues(alpha: 0.3),
                          checkmarkColor: type.color,
                        ),
                      )),
                ],
              ),
            ),
          ),

          // Botón de menú (3 rayas) en la esquina superior derecha
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.menu),
                tooltip: 'Menú principal',
                offset: const Offset(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'perfil':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      ).then((changed) {
                        // Forzamos a repintar el menú para que se actualice el nombre si cambió
                        if (mounted && changed == true) setState(() {});
                      });
                      break;
                    case 'publicaciones':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyPublicationsScreen()),
                      );
                      break;

                    case 'lista':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MarkerListScreen()),
                      ).then((_) {
                        if (mounted) _loadMarkers();
                      });
                      break;
                    case 'tema':
                      ThemeManager().toggleTheme();
                      break;
                    case 'logout':
                      _logout();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, ${AuthService.getUserName()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          AuthService.getUserEmail() ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'perfil',
                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(l10n.menuProfile),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'publicaciones',
                    child: ListTile(
                      leading: const Icon(Icons.list_alt),
                      title: Text(l10n.menuPublications),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  PopupMenuItem(
                    value: 'lista',
                    child: ListTile(
                      leading: const Icon(Icons.format_list_bulleted),
                      title: Text(l10n.menuViewAsList),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'tema',
                    child: ListTile(
                      leading: Icon(ThemeManager().currentThemeId == 0 
                        ? Icons.dark_mode_outlined 
                        : Icons.light_mode_outlined),
                      title: Text(l10n.menuChangeTheme),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text(l10n.menuLogout, style: const TextStyle(color: Colors.red)),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),

      // FAB crear marcador con animación (recolocado a la izquierda)
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: _navigateToCreateMarker,
          icon: const Icon(Icons.add_location_alt),
          label: Text(l10n.newMarkerButton),
          heroTag: 'create_marker_fab',
        ),
      ),
    );
  }
}
