import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciclando/servicios/notification_service.dart';
import 'package:reciclando/l10n/app_localizations.dart';

/// Pantalla que muestra las notificaciones del usuario.
/// Aquí le llegan los avisos cuando alguien recoge sus objetos.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final notifications = await NotificationService.getNotifications();
    if (mounted) {
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllRead() async {
    await NotificationService.markAllAsRead();
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton.icon(
              onPressed: _markAllRead,
              icon: const Icon(Icons.done_all, size: 18),
              label: Text(l10n.notificationsMarkAllRead),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none,
                          size: 80,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.3)),
                      const SizedBox(height: 16),
                      Text(
                        l10n.notificationsEmpty,
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.notificationsEmptyHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notif = _notifications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        elevation: notif.isRead ? 0 : 2,
                        color: notif.isRead
                            ? null
                            : theme.colorScheme.primary
                                .withValues(alpha: 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: notif.isRead
                              ? BorderSide.none
                              : BorderSide(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: notif.isRead
                                ? theme.colorScheme.onSurface
                                    .withValues(alpha: 0.1)
                                : theme.colorScheme.primary
                                    .withValues(alpha: 0.2),
                            child: Icon(
                              notif.isRead
                                  ? Icons.notifications_none
                                  : Icons.notifications_active,
                              color: notif.isRead
                                  ? theme.colorScheme.onSurface
                                      .withValues(alpha: 0.4)
                                  : theme.colorScheme.primary,
                            ),
                          ),
                          title: Text(
                            notif.title,
                            style: TextStyle(
                              fontWeight: notif.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(notif.body),
                              const SizedBox(height: 6),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(notif.createdAt),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            if (!notif.isRead) {
                              await NotificationService.markAsRead(notif.id);
                              _loadNotifications();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
