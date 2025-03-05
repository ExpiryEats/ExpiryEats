import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/widgets/notification_item.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      "ingredientName": "Item 1",
      "daysToExpiry": 7,
      "daysSinceReceived": 1,
    },
    {
      "ingredientName": "Item 2",
      "daysToExpiry": -2,
      "daysSinceReceived": 3,
    },
  ];

  void _removeNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  List<NotificationItem> _populateNotifications() {
    return _notifications.map((notification) {
      return NotificationItem(
        ingredientName: notification["ingredientName"],
        daysToExpiry: notification["daysToExpiry"],
        daysSinceReceived: notification[
            "daysSinceReceived"], //days since the notification was recieved
        onClose: () =>
            _removeNotification(_notifications.indexOf(notification)),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _notifications.isNotEmpty ? Stack(
      children: [
        FadingEdgeScrollView.fromScrollView(
          gradientFractionOnStart: 0.2,
          gradientFractionOnEnd: 0.2,
          child: ListView(
            controller: ScrollController(),
            children: _populateNotifications(),
          ),
        ),
      ],
    ) : Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment(0.0, 0.0),
          child: Text(
            'No Notifications',
            style: AppTextStyle.bold(),
          ),
        ),
      ),
    );
  }
}
