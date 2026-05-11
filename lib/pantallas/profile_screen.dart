import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reciclando/Implementaciones/auth/data/services/auth_service.dart';
import 'package:reciclando/Implementaciones/auth/presentacion/pages/inicio.dart';
import 'package:reciclando/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: AuthService.getUserName());
    _emailController = TextEditingController(text: AuthService.getUserEmail());
    _phoneController = TextEditingController(text: AuthService.getUserPhone());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileNameEmpty)),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    final result = await AuthService.updateProfile(
      _nameController.text.trim(),
      phone: _phoneController.text.trim()
    );
    
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']?.toString() ?? ''),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );
      if (result['success']) {
        Navigator.pop(context, true); // true indica que hubo actualización
      }
    }
  }

  Future<void> _showChangePasswordDialog() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        bool isLoadingPassword = false;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final l10nDialog = AppLocalizations.of(context)!;
            return AlertDialog(
              title: Text(l10nDialog.profileChangePasswordTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10nDialog.profileCurrentPassword),
                  ),
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10nDialog.profileNewPassword),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10nDialog.cancel),
                ),
                ElevatedButton(
                  onPressed: isLoadingPassword
                      ? null
                      : () async {
                          setStateDialog(() => isLoadingPassword = true);
                          final res = await AuthService.updatePassword(
                            currentPasswordController.text,
                            newPasswordController.text,
                          );
                          setStateDialog(() => isLoadingPassword = false);
                          
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(res['message']?.toString() ?? ''),
                                backgroundColor: res['success'] ? Colors.green : Colors.red,
                              ),
                            );
                          }
                        },
                  child: isLoadingPassword
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10nDialog.profileChangeButton),
                ),
              ],
            );
          }
        );
      },
    );
  }

  Future<void> _confirmDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10nDel = AppLocalizations.of(context)!;
        return AlertDialog(
        title: Text(l10nDel.profileDeleteTitle),
        content: Text(l10nDel.profileDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10nDel.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10nDel.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      );
      },
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      final res = await AuthService.deleteAccount();
      if (mounted) {
        setState(() => _isLoading = false);
        if (res['success']) {
          // Navegar al login limpiando toda la pila de rutas
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const Inicio()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message']?.toString() ?? ''), backgroundColor: Colors.red),
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
        title: Text(l10n.profileTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 32),
            // Campo de Nombre (Editable)
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.profileName,
                prefixIcon: const Icon(Icons.person_outline),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Campo de Teléfono (Editable, máx 9 dígitos)
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 9,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.profilePhone,
                prefixIcon: const Icon(Icons.phone_outlined),
                border: const OutlineInputBorder(),
                counterText: '',
              ),
            ),
            const SizedBox(height: 20),
            // Campo de Email (No Editable)
            TextFormField(
              controller: _emailController,
              enabled: false,
              decoration: InputDecoration(
                labelText: l10n.profileEmail,
                prefixIcon: const Icon(Icons.email_outlined),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.profileEmailNote,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.profileSave, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: _showChangePasswordDialog,
              child: Text(l10n.profileChangePassword),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _confirmDeleteAccount,
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.profileDeleteAccount),
            ),
          ],
        ),
      ),
    );
  }
}
