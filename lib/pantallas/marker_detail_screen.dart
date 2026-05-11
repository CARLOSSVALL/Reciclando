import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciclando/l10n/app_localizations.dart';
import 'package:reciclando/modelos/marker_model.dart';
import 'package:reciclando/servicios/marker_service.dart';
import 'package:reciclando/servicios/location_service.dart';

/// Pantalla de detalle de un marcador de reciclaje.
/// Muestra la foto, tipo, descripción, creador y botón de recoger.
class MarkerDetailScreen extends StatefulWidget {
  final RecycleMarker marker;

  const MarkerDetailScreen({super.key, required this.marker});

  @override
  State<MarkerDetailScreen> createState() => _MarkerDetailScreenState();
}

class _MarkerDetailScreenState extends State<MarkerDetailScreen> {
  late RecycleMarker _marker;

  /// Formato de fecha reutilizable
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  bool _canCollect = false;
  bool _isLoadingDistance = true;

  @override
  void initState() {
    super.initState();
    _marker = widget.marker;
    _checkDistance();
  }

  Future<void> _checkDistance() async {
    final pos = await LocationService.getCurrentPosition();
    if (pos != null && mounted) {
      final distance = LocationService.getDistance(
        pos.latitude, pos.longitude,
        _marker.latitude, _marker.longitude,
      );
      if (distance <= 1000) {
        setState(() => _canCollect = true);
      }
    }
    if (mounted) {
      setState(() => _isLoadingDistance = false);
    }
  }

  /// Registrar recolección (borrar publicación y notificar al dueño vía backend)
  Future<void> _collect() async {
    if (!_canCollect) return;
    final l10n = AppLocalizations.of(context)!;

    final result = await MarkerService.collectMarker(_marker.id);
    if (mounted) {
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.collectedSuccess(result['ownerName']?.toString() ?? '')),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
        Navigator.pop(context, true); // Cerramos pantalla de detalle
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']?.toString() ?? l10n.collectError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen de fondo
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _marker.type.getLocalizedLabel(l10n),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(blurRadius: 10, color: Colors.black54),
                  ],
                ),
              ),
              background: _marker.photoUrl.isNotEmpty
                  ? Hero(
                      tag: 'marker_photo_${_marker.id}',
                      child: Image.network(
                              _marker.photoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                                child: Icon(
                                  _marker.type.icon,
                                  size: 80,
                                  color: _marker.type.color,
                                ),
                              ),
                            ),
                    )
                  : Container(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      child: Icon(
                        _marker.type.icon,
                        size: 80,
                        color: _marker.type.color,
                      ),
                    ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chip de tipo
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _marker.type.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_marker.type.icon,
                            size: 20, color: _marker.type.color),
                        const SizedBox(width: 8),
                        Text(
                          _marker.type.getLocalizedLabel(l10n),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _marker.type.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Descripción
                  Text(
                    l10n.detailDescription,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _marker.description.isNotEmpty
                        ? _marker.description
                        : l10n.detailNoDescription,
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Información del creador
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _infoRow(
                            icon: Icons.person,
                            label: l10n.detailPublishedBy,
                            value: _marker.userName,
                            theme: theme,
                          ),
                          if (_marker.userEmail.isNotEmpty) ...[
                            const Divider(height: 20),
                            _infoRow(
                              icon: Icons.email,
                              label: l10n.detailEmail,
                              value: _marker.userEmail,
                              theme: theme,
                            ),
                          ],
                          if (_marker.userPhone.isNotEmpty) ...[
                            const Divider(height: 20),
                            _infoRow(
                              icon: Icons.phone,
                              label: l10n.profilePhone,
                              value: _marker.userPhone,
                              theme: theme,
                            ),
                          ],
                          const Divider(height: 20),
                          _infoRow(
                            icon: Icons.calendar_today,
                            label: l10n.detailDate,
                            value: _dateFormat.format(_marker.createdAt),
                            theme: theme,
                          ),
                          const Divider(height: 20),
                          _infoRow(
                            icon: Icons.location_on,
                            label: l10n.detailCoordinates,
                            value:
                                '${_marker.latitude.toStringAsFixed(4)}, ${_marker.longitude.toStringAsFixed(4)}',
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón Recoger
                  Card(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoadingDistance || !_canCollect ? null : _collect,
                              icon: _isLoadingDistance 
                                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Icon(Icons.local_shipping),
                              label: Text(
                                _isLoadingDistance 
                                    ? l10n.detailCalculatingDistance
                                    : (_canCollect ? l10n.detailCollect : l10n.detailTooFar),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: _canCollect ? theme.colorScheme.primary : Colors.grey,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fila informativa reutilizable
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
