import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final Map<String, dynamic> subscription;
  final VoidCallback onDelete;

  SubscriptionCard({required this.subscription, required this.onDelete});

  String _calculateTimeRemaining(String billingDate, String billingCycle) {
    final DateTime now = DateTime.now();
    DateTime nextBillingDate = DateTime.parse(billingDate);

    // Adjust the next billing date based on the billing cycle
    while (nextBillingDate.isBefore(now)) {
      if (billingCycle == 'Weekly') {
        nextBillingDate = nextBillingDate.add(const Duration(days: 7));
      } else if (billingCycle == 'Monthly') {
        nextBillingDate = DateTime(
          nextBillingDate.year,
          nextBillingDate.month + 1,
          nextBillingDate.day,
        );
      } else if (billingCycle == 'Yearly') {
        nextBillingDate = DateTime(
          nextBillingDate.year + 1,
          nextBillingDate.month,
          nextBillingDate.day,
        );
      } else {
        return "Unknown cycle";
      }
    }

    final Duration difference = nextBillingDate.difference(now);
    if (billingCycle == 'Weekly' || billingCycle == 'Monthly') {
      return "${difference.inDays} days";
    }
    if (billingCycle == 'Yearly') {
      return "${(difference.inDays / 30).floor()} m, ${difference.inDays % 30} days";
    }

    return "Unknown cycle";
  }

  @override
  Widget build(BuildContext context) {
    String timeRemaining = _calculateTimeRemaining(
      subscription['billingDate'] ?? '',
      subscription['billingCycle'] ?? 'Unknown',
    );

    return Card(
      color: Color(subscription['selectedIconColor'] ??
          0xFF000000), // Default color if missing
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Left Circular Icon
            CircleAvatar(
              backgroundColor: Colors.white, // Fondo del círculo
              child: Icon(
                IconData(
                  subscription['selectedIconCodePoint'] ?? Icons.help.codePoint,
                  fontFamily: subscription['selectedIconFontFamily'] ??
                      'FontAwesomeSolid', // FontAwesome o predeterminado
                  fontPackage:
                      'font_awesome_flutter', // Específico para FontAwesome
                ),
                color: Color(subscription['selectedIconColor'] ?? 0xFF000000),
              ),
            ),

            const SizedBox(width: 16),

            // Column with Title and Subtitle
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription['name'] ?? 'No Name', // Fallback title
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subscription['description'] ??
                        'No Description', // Fallback description
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 2),

            // Column with Amount and Time Remaining
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${subscription['amount'] ?? '0.00'} ${subscription['currency'] ?? 'USD'}', // Fallback amount and currency
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeRemaining,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),

            // Column with Delete Icon
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
