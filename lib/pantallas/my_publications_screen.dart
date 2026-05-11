import 'package:flutter/material.dart';
import 'package:reciclando/modelos/marker_model.dart';
import 'package:reciclando/servicios/marker_service.dart';
import 'package:reciclando/pantallas/marker_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:reciclando/l10n/app_localizations.dart';

class MyPublicationsScreen extends StatefulWidget {
  const MyPublicationsScreen({super.key});

  @override
  State<MyPublicationsScreen> createState() => _MyPublicationsScreenState();
}

class _MyPublicationsScreenState extends State<MyPublicationsScreen> {
  List<RecycleMarker> _myMarkers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyMarkers();
  }

  Future<void> _loadMyMarkers() async {
    setState(() => _isLoading = true);
    final markers = await MarkerService.getMyMarkers();
    if (mounted) {
      setState(() {
        _myMarkers = markers;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteMarker(String id) async {
    final l10n = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.myPublicationsDeleteTitle),
        content: Text(l10n.myPublicationsDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await MarkerService.deleteMarker(id);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.deleteSuccess),
              backgroundColor: Colors.green,
            ),
          );
          _loadMyMarkers();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.deleteError),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myPublicationsTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _myMarkers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        l10n.myPublicationsEmpty,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _myMarkers.length,
                  itemBuilder: (context, index) {
                    final marker = _myMarkers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12.0),
                        leading: CircleAvatar(
                          backgroundColor: marker.type.color.withValues(alpha: 0.2),
                          child: Icon(marker.type.icon, color: marker.type.color),
                        ),
                        title: Text(
                          marker.type.getLocalizedLabel(l10n),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              marker.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(marker.createdAt),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _deleteMarker(marker.id),
                              tooltip: l10n.delete,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MarkerDetailScreen(marker: marker),
                            ),
                          ).then((_) => _loadMyMarkers());
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
