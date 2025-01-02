import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsapp/components/subscription_card.dart';
import 'package:subsapp/screens/add_subscription_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.75
  }; // Tipos de cambio

  Map<String, String> _currencySymbols = {
    'USD': '\$', // Dollar
    'EUR': '€', // Euro
    'GBP': '£', // British Pound
  };

  String formatNumber(double number) {
    final formatter =
        NumberFormat("#,##0.00", "es_ES"); // Formato para región española
    return formatter.format(number);
  }

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('subscriptions');
    if (data != null) {
      final loadedSubscriptions =
          List<Map<String, dynamic>>.from(json.decode(data));
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

  Future<void> _launchURL() async {
    const url = 'https://www.example.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double monthlyAverage =
        _calculateAverage('Monthly') * _exchangeRates[_currentCurrency]!;
    double yearlyAverage =
        _calculateAverage('Yearly') * _exchangeRates[_currentCurrency]!;
    double weeklyAverage =
        _calculateAverage('Weekly') * _exchangeRates[_currentCurrency]!;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Subscriptions')),
        leading: IconButton(
          icon: const Icon(Icons.info),
          onPressed: _launchURL,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _switchCurrency,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total $_currentCurrency',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    'Monthly:',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${formatNumber(monthlyAverage)} ${_currencySymbols[_currentCurrency]}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    'Yearly:',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${formatNumber(yearlyAverage)} ${_currencySymbols[_currentCurrency]}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}
