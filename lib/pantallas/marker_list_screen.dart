import 'package:flutter/material.dart';
import 'package:reciclando/modelos/marker_model.dart';
import 'package:reciclando/servicios/marker_service.dart';
import 'package:reciclando/pantallas/marker_detail_screen.dart';
import 'package:reciclando/l10n/app_localizations.dart';
import 'package:reciclando/servicios/location_service.dart';

class MarkerListScreen extends StatefulWidget {
  const MarkerListScreen({super.key});

  @override
  State<MarkerListScreen> createState() => _MarkerListScreenState();
}

class _MarkerListScreenState extends State<MarkerListScreen> {
  late Future<List<RecycleMarker>> _markersFuture;

  @override
  void initState() {
    super.initState();
    _loadMarkersWithDistance();
  }

  void _loadMarkersWithDistance() {
    setState(() {
      _markersFuture = LocationService.getCurrentPosition().then((pos) {
        return MarkerService.getMarkers(
          lat: pos?.latitude,
          lng: pos?.longitude,
        );
      });
    });
  }

  Future<void> _refreshMarkers() async {
    _loadMarkersWithDistance();
    await _markersFuture;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.markerListTitle),
      ),
      body: FutureBuilder<List<RecycleMarker>>(
        future: _markersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(l10n.markerListError));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(l10n.markerListEmpty));
          }

          final markers = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshMarkers,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: markers.length,
              itemBuilder: (context, index) {
                final marker = markers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: marker.type.color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(marker.type.icon, color: marker.type.color),
                    ),
                    title: Text(
                      '${marker.type.getLocalizedLabel(l10n)} - ${marker.userName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        marker.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MarkerDetailScreen(marker: marker),
                        ),
                      ).then((_) => _refreshMarkers());
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
