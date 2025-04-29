import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';
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

  void _confirmRemoveNotification(int index) {
    showDialog(
      
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Notification"),
          content: Text("Are you sure you want to remove this notification?"),
          actions: [
            TextButton(
            
              onPressed: () => Navigator.of(context).pop(), 
              child: Text("Cancel"),
            ),
            TextButton(
     
              onPressed: () {
                Navigator.of(context).pop(); 
                _removeNotification(index); 
              },
              child: Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

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
        daysSinceReceived: notification["daysSinceReceived"],
        onClose:
            () => 
                _confirmRemoveNotification(
                    _notifications.indexOf(notification)),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _notifications.isNotEmpty
        ? Stack(
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
          )
        : Align(
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
