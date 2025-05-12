import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/widgets/notification_item.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:expiry_eats/managers/database_manager.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/managers/cache_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final personId = Provider.of<CacheProvider>(context, listen: false).cache.userId;
    if (personId == null) return;

    final data = await DatabaseService().getNotifications(personId, dismissed: false);
    setState(() {
      _notifications = data;
    });
  }

  Future<void> _removeNotification(int index) async {
    final id = _notifications[index]['notification_id'];
    await DatabaseService().dismissNotification(id);
    setState(() {
      _notifications.removeAt(index);
    });
  }

  void _confirmRemoveNotification(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Notification"),
          content: const Text("Are you sure you want to remove this notification?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeNotification(index);
              },
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  List<NotificationItem> _populateNotifications(List<Map<String, dynamic>> notificationTypes) {
    return _notifications.map((notification) {
      final sent = DateTime.parse(notification['sent_at']);
      final now = DateTime.now();
      final daysSinceReceived = now.difference(sent).inDays;

      final typeId = notification['type_id'];
      final typeName = notificationTypes.firstWhere(
        (type) => type['type_id'] == typeId,
        orElse: () => {'type_name': 'Unknown'},
      )['type_name'];

      return NotificationItem(
        typeName: typeName,
        message: notification['message'],
        daysSinceReceived: daysSinceReceived,
        onClose: () => _confirmRemoveNotification(_notifications.indexOf(notification)),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final notificationTypes = Provider.of<CacheProvider>(context).cache.notificationTypes;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: _notifications.isNotEmpty
          ? FadingEdgeScrollView.fromScrollView(
              gradientFractionOnStart: 0.2,
              gradientFractionOnEnd: 0.2,
              child: ListView(
                controller: ScrollController(),
                children: _populateNotifications(notificationTypes),
              ),
            )
          : Center(
              child: Text(
                'No Notifications',
                style: AppTextStyle.bold(),
              ),
            ),
    );
  }
}