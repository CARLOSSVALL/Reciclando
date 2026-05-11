import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reciclando/modelos/marker_model.dart';
import 'package:reciclando/servicios/marker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciclando/nucleo/utils/app_logger.dart';
import 'package:reciclando/l10n/app_localizations.dart';

/// Pantalla para crear un nuevo marcador de reciclaje.
/// Permite seleccionar tipo, descripción y foto del objeto.
class CreateMarkerScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const CreateMarkerScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<CreateMarkerScreen> createState() => _CreateMarkerScreenState();
}

class _CreateMarkerScreenState extends State<CreateMarkerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();

  MarkerType _selectedType = MarkerType.otros;
  XFile? _selectedXFile;
  bool _isUploading = false;
  double _uploadProgress = 0;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// Seleccionar foto desde cámara o galería
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        setState(() => _selectedXFile = image);
      }
    } catch (e) {
      AppLogger.error('Error al seleccionar imagen',
          tag: 'CreateMarker', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.cameraError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Guardar marcador
  Future<void> _saveMarker() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedXFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.createMarkerPhotoRequired),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    final result = await MarkerService.createMarker(
      type: _selectedType,
      description: _descriptionController.text.trim(),
      latitude: widget.latitude,
      longitude: widget.longitude,
      photoXFile: _selectedXFile!,
      onProgress: (progress) {
        if (mounted) {
          setState(() => _uploadProgress = progress);
        }
      },
    );

    if (mounted) {
      setState(() => _isUploading = false);

      if (result != null) {
        // Animación de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.createMarkerSuccess),
            backgroundColor: Colors.green,
          ),
        );
        // Volver con resultado positivo
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.createMarkerError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Diálogo para elegir cámara o galería
  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: Text(AppLocalizations.of(context)!.camera),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: Text(AppLocalizations.of(context)!.gallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createMarkerTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección: Tipo de objeto
              Text(
                l10n.createMarkerTypeQuestion,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MarkerType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(type.label),
                    avatar: Icon(type.icon, size: 20, color: type.color),
                    selected: isSelected,
                    selectedColor: type.color.withValues(alpha: 0.25),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedType = type);
                      }
                    },
                    labelStyle: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected ? type.color : theme.colorScheme.onSurface,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Sección: Descripción
              Text(
                l10n.createMarkerDescription,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: l10n.createMarkerDescriptionHint,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Icon(Icons.edit_note),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.createMarkerDescriptionRequired;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Sección: Foto
              Text(
                l10n.createMarkerPhoto,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              // Preview de foto o botón para añadir
              GestureDetector(
                onTap: _showImagePickerDialog,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedXFile != null
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: _selectedXFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              kIsWeb
                                  ? Image.network(
                                      _selectedXFile!.path,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_selectedXFile!.path),
                                      fit: BoxFit.cover,
                                    ),
                              // Botón de cambiar
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.refresh,
                                        color: Colors.white),
                                    onPressed: _showImagePickerDialog,
                                    tooltip: l10n.changePhoto,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.createMarkerTapToAdd,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.createMarkerCameraOrGallery,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // Ubicación actual
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.my_location,
                        size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.createMarkerLocation(widget.latitude.toStringAsFixed(4), widget.longitude.toStringAsFixed(4)),
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Barra de progreso al subir
              if (_isUploading) ...[
                LinearProgressIndicator(
                  value: _uploadProgress,
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.15),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.createMarkerUploading((_uploadProgress * 100).toInt()),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 16),
              ],

              // Botón Guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isUploading ? null : _saveMarker,
                  icon: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_alt),
                  label: Text(
                    _isUploading ? l10n.createMarkerSaving : l10n.createMarkerSave,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
