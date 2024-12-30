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
  String _currentCurrency = 'USD'; // Moneda seleccionada
  Map<String, double> _exchangeRates = {'USD': 1.0, 'EUR': 0.85, 'GBP': 0.75}; // Tipos de cambio

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('subscriptions');
    if (data != null) {
      final loadedSubscriptions = List<Map<String, dynamic>>.from(json.decode(data));
      setState(() {
        _subscriptions = loadedSubscriptions;
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

  double _calculateAverage(String view) {
    if (_subscriptions.isEmpty) return 0.0;
    double total = 0.0;

    for (var sub in _subscriptions) {
      double amount = sub['amount'];
      String cycle = sub['billingCycle'];

      if (view == 'Monthly') {
        if (cycle == 'Monthly') {
          total += amount;
        } else if (cycle == 'Yearly') {
          total += amount / 12;
        } else if (cycle == 'Weekly') {
          total += amount * 4.33;
        }
      } else if (view == 'Yearly') {
        if (cycle == 'Monthly') {
          total += amount * 12;
        } else if (cycle == 'Yearly') {
          total += amount;
        } else if (cycle == 'Weekly') {
          total += amount * 52;
        }
      } else if (view == 'Weekly') {
        if (cycle == 'Monthly') {
          total += amount / 4.33;
        } else if (cycle == 'Yearly') {
          total += amount / 52;
        } else if (cycle == 'Weekly') {
          total += amount;
        }
      }
    }

    return total / _subscriptions.length;
  }

  void _switchCurrency() {
    setState(() {
      // Cambiar entre monedas
      if (_currentCurrency == 'USD') {
        _currentCurrency = 'EUR';
      } else if (_currentCurrency == 'EUR') {
        _currentCurrency = 'GBP';
      } else if (_currentCurrency == 'GBP') {
        _currentCurrency = 'USD';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double monthlyAverage = _calculateAverage('Monthly') * _exchangeRates[_currentCurrency]!;
    double yearlyAverage = _calculateAverage('Yearly') * _exchangeRates[_currentCurrency]!;
    double weeklyAverage = _calculateAverage('Weekly') * _exchangeRates[_currentCurrency]!;

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
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 35.0), // Más margen en la parte inferior
            child: Column(
              children: [
                GestureDetector(
                  onTap: _switchCurrency,
                  child: Text(
                    'Currency: $_currentCurrency',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Monthly Average: ${monthlyAverage.toStringAsFixed(2)} $_currentCurrency',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yearly Average: ${yearlyAverage.toStringAsFixed(2)} $_currentCurrency',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Weekly Average: ${weeklyAverage.toStringAsFixed(2)} $_currentCurrency',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
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
