import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final String ingredientName;
  final int daysToExpiry;
  final int daysSinceReceived;
  final VoidCallback onClose;

  const NotificationItem({
    super.key,
    required this.ingredientName,
    required this.daysToExpiry,
    required this.daysSinceReceived, //days since the notification was recieved
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: daysToExpiry < 0 ? Colors.red : Colors.yellow,
      child: Stack(
        children: [
          InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint("Notification tapped");
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 120,
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ingredientName,
                            style: AppTextStyle.bold(),
                          ),
                          Text(
                            daysToExpiry < 0
                                ? "Has expired"
                                : "$daysToExpiry days from expiring",
                            style: AppTextStyle.small(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: -6, // Moves the button slightly more to the right
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: onClose,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "$daysSinceReceived days ago",
                    style: AppTextStyle.small(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
