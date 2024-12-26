import 'package:flutter/material.dart';

class IconPickerScreen extends StatefulWidget {
  const IconPickerScreen({Key? key}) : super(key: key);

  @override
  State<IconPickerScreen> createState() => _IconPickerScreenState();
}

class _IconPickerScreenState extends State<IconPickerScreen> {
  final List<IconData> _icons = [
    Icons.shopping_cart,
    Icons.movie,
    Icons.music_note,
    Icons.sports_esports,
    Icons.local_dining,
    Icons.flight,
    Icons.home,
    Icons.fitness_center,
    Icons.school,
    Icons.car_rental,
    // Agrega más íconos según sea necesario
  ];

  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    List<IconData> filteredIcons = _icons
        .where((icon) => icon.toString().contains(_searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select an Icon"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search Icons",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: filteredIcons.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, filteredIcons[index]);
                  },
                  child: Card(
                    child: Center(
                      child: Icon(filteredIcons[index], size: 30),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
