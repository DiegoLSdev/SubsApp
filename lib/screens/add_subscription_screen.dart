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
  IconWithColor? _selectedIconWithColor;

  final _formKey = GlobalKey<FormState>();

  void _selectIcon() async {
    final result = await Navigator.push<IconWithColor>(
      context,
      MaterialPageRoute(builder: (context) => const IconPickerScreen()),
    );
    if (result != null) {
      setState(() {
        _selectedIconWithColor = result;
        print(_selectedIconWithColor?.color);
        print(_selectedIconWithColor?.icon);
      });
    }
  }

  void _saveSubscription() {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final newSubscription = {
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'category': _selectedCategory,
          'categoryColor': _selectedCategoryColor.value,
          'amount': double.tryParse(_amountController.text.trim()) ?? 0.0,
          'currency': _currency,
          'billingDate': _billingDate.toIso8601String(),
          'billingCycle': _billingCycle,
          'selectedIconCodePoint': _selectedIconWithColor?.icon.codePoint,
          'selectedIconFontFamily': _selectedIconWithColor?.icon.fontFamily,
          'selectedIconColor': _selectedIconWithColor?.color.value,
        };

        Navigator.pop(context, newSubscription);
      } catch (e) {
        // Log or handle unexpected errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save subscription: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please correct the errors in the form')),
      );
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Add icon"),
              IconButton(
                icon: Icon(
                  _selectedIconWithColor?.icon ?? Icons.add,
                  size: 30,
                  color: _selectedIconWithColor?.color ?? Colors.black,
                ),
                onPressed: _selectIcon,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Amount'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Amount cannot be empty';
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
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
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CategoryColorPicker(
                      selectedCategory: _selectedCategory,
                      selectedColor: _selectedCategoryColor,
                      onCategoryChanged: (category, color) {
                        setState(() {
                          _selectedCategory = category;
                          _selectedCategoryColor = color;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ListTile(
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
                        if (pickedDate != null) {
                          setState(() {
                            _billingDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
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
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveSubscription,
                child: Text('Save Subscription'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
