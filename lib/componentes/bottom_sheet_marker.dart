import 'package:flutter/material.dart';
import 'package:reciclando/l10n/app_localizations.dart';
import 'package:reciclando/modelos/marker_model.dart';

/// Bottom sheet que se muestra al tocar un marcador en el mapa.
/// Muestra miniatura de foto, tipo, descripción y botón "Ver más".
class BottomSheetMarker extends StatelessWidget {
  final RecycleMarker marker;
  final VoidCallback onViewDetails;
  final VoidCallback? onCollect;

  const BottomSheetMarker({
    super.key,
    required this.marker,
    required this.onViewDetails,
    this.onCollect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Miniatura de foto
              Hero(
                tag: 'marker_photo_${marker.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: marker.photoUrl.isNotEmpty
                        ? Image.network(
                            marker.photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: marker.type.color.withValues(alpha: 0.2),
                              child: Icon(marker.type.icon,
                                  color: marker.type.color),
                            ),
                          )
                        : Container(
                            color: marker.type.color.withValues(alpha: 0.2),
                            child: Icon(marker.type.icon,
                                color: marker.type.color),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info del marcador
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipo con chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: marker.type.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(marker.type.icon,
                              size: 14, color: marker.type.color),
                          const SizedBox(width: 4),
                          Text(
                            marker.type.getLocalizedLabel(l10n),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: marker.type.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Descripción (truncada)
                    Text(
                      marker.description.isNotEmpty
                          ? marker.description
                          : l10n.detailNoDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Usuario
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 14,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Text(
                          marker.userName,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.visibility),
                  label: Text(l10n.bottomSheetViewDetails),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCollect,
                  icon: const Icon(Icons.local_shipping),
                  label: Text(onCollect != null ? l10n.bottomSheetCollect : l10n.bottomSheetTooFar),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
