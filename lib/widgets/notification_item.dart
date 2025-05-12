import 'package:expiry_eats/styles.dart';
import 'package:expiry_eats/colors.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final String typeName;
  final String message;
  final DateTime sentAt; // changed from daysSinceReceived
  final VoidCallback onClose;

  const NotificationItem({
    super.key,
    required this.typeName,
    required this.message,
    required this.sentAt,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final String lowerMsg = message.toLowerCase();
    final bool isExpired = lowerMsg.contains('expired');
    final bool isToday = lowerMsg.contains('today') || lowerMsg.contains('0 day');

    final Color iconColor = isExpired
        ? const Color(0xFFD9534F) // soft red
        : isToday
            ? const Color(0xFFFF9900) // warm orange
            : const Color(0xFF5CB85C); // calm green;

    final int hoursAgo = DateTime.now().difference(sentAt).inHours;

    return Card(
      color: AppTheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(
                isExpired ? Icons.error_rounded : Icons.access_time,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(typeName, style: AppTextStyle.bold()),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: AppTextStyle.small().copyWith(color: Colors.black87),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Text(
                  "$hoursAgo hour${hoursAgo == 1 ? '' : 's'} ago",
                  style: AppTextStyle.small().copyWith(color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}