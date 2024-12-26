import 'package:flutter/material.dart';
import 'package:subsapp/screens/icon_picker_screen.dart';
import 'package:subsapp/widgets/category_color_picker.dart';

class AddSubscriptionScreen extends StatefulWidget {
  @override
  _AddSubscriptionScreenState createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'General';
  Color _selectedCategoryColor = Colors.purple;
  String _currency = 'USD';
  DateTime _billingDate = DateTime.now();
  String _billingCycle = 'Monthly';
  IconData? _selectedIcon;


    void _selectIcon() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IconPickerScreen()),
    );
    if (result != null) {
      setState(() {
        _selectedIcon = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Subscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            DropdownButtonFormField<String>(
              value: _currency,
              items: ['USD', 'EUR', 'JPY', 'GBP', 'INR']
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _currency = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Currency'),
            ),
            CategoryColorPicker(
              selectedCategory: _selectedCategory,
              selectedColor: _selectedCategoryColor,
              onCategoryChanged: (category, color) {
                setState(() {
                  _selectedCategory = category;
                  _selectedCategoryColor = color;
                });
              },
            ),
            ListTile(
              title: Text('Billing Date'),
              subtitle: Text('${_billingDate.toLocal()}'.split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _billingDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _billingDate) {
                  setState(() {
                    _billingDate = pickedDate;
                  });
                }
              },
            ),
            DropdownButtonFormField<String>(
              value: _billingCycle,
              items: ['Monthly', 'Yearly', 'Weekly']
                  .map((cycle) => DropdownMenuItem(
                        value: cycle,
                        child: Text(cycle),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _billingCycle = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Billing Cycle'),
            ),

                              IconButton(
                    icon: Icon(
                      _selectedIcon ?? Icons.add,
                      size: 30,
                    ),
                    onPressed: _selectIcon,
                  ),
                
              
              


            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  final newSubscription = {
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                    'category': _selectedCategory,
                    'categoryColor': _selectedCategoryColor.value,
                    'amount': double.tryParse(_amountController.text) ?? 0.0,
                    'currency': _currency,
                    'billingDate': _billingDate.toIso8601String(),
                    'billingCycle': _billingCycle,
                    'selectedIcon': _selectedIcon,
                  };
                  Navigator.pop(context, newSubscription);
                }
              },
              child: Text('Save Subscription'),
            ),
          ],
        ),
      ),
    );
  }
}
