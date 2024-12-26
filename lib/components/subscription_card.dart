import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final Map<String, dynamic> subscription;
  final VoidCallback onDelete;

  SubscriptionCard({required this.subscription, required this.onDelete});

  String _calculateTimeRemaining(String billingDate, String billingCycle) {
    final DateTime now = DateTime.now();
    int nowYear = now.year; // Extracts the year, e.g., 2024
    int nowMonth = now.month; // Extracts the year, e.g., 2024
    final DateTime nextBillingDate = DateTime.parse(billingDate);
    final Duration difference = nextBillingDate.difference(now);

    if (billingCycle == 'Weekly') {
      return "working on this";
    }
    if (billingCycle == 'Monthly') {
      return "X Days left to pay";
    }
    if (billingCycle == 'Yearly') {
      return "X Monts to pay";
    }

    return "hi";
  }

  @override
  Widget build(BuildContext context) {
    String timeRemaining = _calculateTimeRemaining(
    subscription['billingDate'], subscription['billingCycle']);

    return Card(
      child: ListTile(
        leading: Icon(
          subscription['selectedIcon'] ?? Icons.subscriptions,
          size: 40,
        ),
        //CircleAvatar(
        //backgroundColor: Color(subscription['categoryColor']),
        //),

        title: Text(subscription['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${subscription['description']} - ${subscription['currency']} ${subscription['amount'].toStringAsFixed(2)}'),
            Text(
              subscription['billingCycle'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              timeRemaining,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
