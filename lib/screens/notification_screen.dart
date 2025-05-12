import 'package:flutter/material.dart';
import 'package:expiry_eats/styles.dart';
import 'package:expiry_eats/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final SupabaseClient client = Supabase.instance.client;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await client
          .from('notification')
          .select(
              'notification_id, person_id, message, type_id, read_status, send_at, notification_type(type_name)')
          .eq('person_id', userId)
          .order('send_at', ascending: false);

      setState(() {
        _notifications = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error loading notifications: $e");
    }
  }

  Future<void> _markAsRead(int notificationId) async {
    await client
        .from('notification')
        .update({'read_status': true}).eq('notification_id', notificationId);
    _loadNotifications();
  }

  Future<void> _deleteNotification(int notificationId) async {
    await client
        .from('notification')
        .delete()
        .eq('notification_id', notificationId);
    _loadNotifications();
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final bool isRead = notification['read_status'] == true;
    final String message = notification['message'] ?? '';
    final String typeName =
        notification['notification_type']['type_name'] ?? '';
    final String formattedDate = DateFormat('dd/MM/yyyy hh:mm a')
        .format(DateTime.parse(notification['send_at']));

    final Color backgroundColor =
        isRead ? Colors.grey.shade200 : AppTheme.primary10;

    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          typeName,
          style: AppTextStyle.bold(),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: AppTextStyle.standard()),
            const SizedBox(height: 4),
            Text(formattedDate, style: AppTextStyle.small()),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'mark') _markAsRead(notification['notification_id']);
            if (value == 'delete')
              _deleteNotification(notification['notification_id']);
          },
          itemBuilder: (context) => [
            if (!isRead)
              const PopupMenuItem(value: 'mark', child: Text('Mark as Read')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.primary40,
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Text('No notifications', style: AppTextStyle.bold()),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(_notifications[index]);
              },
            ),
    );
  }
}
