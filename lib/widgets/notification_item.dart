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
    required this.daysSinceReceived,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final bool isExpired = daysToExpiry < 0;
    final Color cardColor = isExpired ? const Color(0xFFF45D53) : const Color(0xFFffdb4b);

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(
                isExpired ? Icons.warning_rounded : Icons.access_time,
                color: isExpired ? const Color(0xFFF45D53) : const Color(0xFFffdb4b),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(ingredientName, style: AppTextStyle.bold()),
                  const SizedBox(height: 2),
                  Text(
                    isExpired ? "Has expired" : "Expires in $daysToExpiry day${daysToExpiry == 1 ? '' : 's'}",
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
                  "$daysSinceReceived day${daysSinceReceived == 1 ? '' : 's'} ago",
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