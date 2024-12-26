import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsapp/components/subscription_card.dart';
import 'package:subsapp/screens/add_subscription_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Subscriptions App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SubscriptionsScreen(),
    );
  }
}

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<Map<String, dynamic>> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('subscriptions');
    if (data != null) {
      setState(() {
        _subscriptions = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  Future<void> _saveSubscriptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('subscriptions', json.encode(_subscriptions));
  }

  void _addSubscription(Map<String, dynamic> subscription) {
    setState(() {
      _subscriptions.add(subscription);
    });
    _saveSubscriptions();
  }

  void _deleteSubscription(int index) {
    setState(() {
      _subscriptions.removeAt(index);
    });
    _saveSubscriptions();
  }

  double _calculateMonthlyAverage() {
    if (_subscriptions.isEmpty) return 0.0;
    double total = 0.0;

    for (var sub in _subscriptions) {
      double amount = sub['amount'];
      String cycle = sub['billingCycle'];

      if (cycle == 'Monthly') {
        total += amount;
      } else if (cycle == 'Yearly') {
        total += amount / 12;
      } else if (cycle == 'Weekly') {
        total += amount * 4.33; // Aproximadamente 4.33 semanas por mes
      }
    }
    return total / _subscriptions.length;
  }

  @override
  Widget build(BuildContext context) {
    double monthlyAverage = _calculateMonthlyAverage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _subscriptions.isEmpty
                ? const Center(child: Text('No subscriptions added.'))
                : ListView.builder(
                    itemCount: _subscriptions.length,
                    itemBuilder: (context, index) {
                      return SubscriptionCard(
                        subscription: _subscriptions[index],
                        onDelete: () => _deleteSubscription(index),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Monthly Average: \$${monthlyAverage.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSubscriptionScreen(),
            ),
          );
          if (result != null) {
            _addSubscription(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
