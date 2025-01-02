import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconPickerScreen extends StatefulWidget {
  const IconPickerScreen({super.key});

  @override
  State<IconPickerScreen> createState() => _IconPickerScreenState();
}

class IconWithColor {
  final IconData icon;
  final Color color;

  IconWithColor(this.icon, this.color);
}

class _IconPickerScreenState extends State<IconPickerScreen> {
final Map<IconData, Map<String, dynamic>> _iconsWithDetails = {
  // Tecnología y Plataformas Digitales
  FontAwesomeIcons.apple: {'color': Colors.black, 'name': 'Apple'},
  FontAwesomeIcons.microsoft: {'color': Colors.lightBlue, 'name': 'Microsoft'},
  FontAwesomeIcons.google: {'color': Colors.blueAccent, 'name': 'Google'},
  FontAwesomeIcons.aws: {'color': Colors.orange, 'name': 'AWS'},
  FontAwesomeIcons.digitalOcean: {'color': Colors.blue, 'name': 'DigitalOcean'},
  FontAwesomeIcons.github: {'color': Colors.black, 'name': 'GitHub'},
  FontAwesomeIcons.gitlab: {'color': Colors.deepOrange, 'name': 'GitLab'},
  FontAwesomeIcons.bitbucket: {'color': Colors.lightBlue, 'name': 'Bitbucket'},
  FontAwesomeIcons.figma: {'color': Colors.black, 'name': 'Figma'},
  FontAwesomeIcons.slack: {'color': Colors.deepPurpleAccent, 'name': 'Slack'},
  FontAwesomeIcons.discord: {'color': Colors.indigo, 'name': 'Discord'},

  // Entretenimiento
  FontAwesomeIcons.spotify: {'color': Colors.green, 'name': 'Spotify'},
  FontAwesomeIcons.youtube: {'color': Colors.redAccent, 'name': 'YouTube'},
  FontAwesomeIcons.amazon: {'color': Colors.orange, 'name': 'Amazon'},
  FontAwesomeIcons.twitch: {'color': Colors.deepPurple, 'name': 'Twitch'},
  FontAwesomeIcons.vimeo: {'color': Colors.lightBlue, 'name': 'Vimeo'},
  FontAwesomeIcons.soundcloud: {'color': Colors.deepOrange, 'name': 'SoundCloud'},
  FontAwesomeIcons.deezer: {'color': Colors.indigo, 'name': 'Deezer'},
  FontAwesomeIcons.audible: {'color': Colors.orange, 'name': 'Audible'},
  FontAwesomeIcons.scribd: {'color': Colors.blue, 'name': 'Scribd'},
  FontAwesomeIcons.patreon: {'color': Colors.deepOrange, 'name': 'Patreon'},

  // Redes Sociales
  FontAwesomeIcons.facebook: {'color': Colors.blueAccent, 'name': 'Facebook'},
  FontAwesomeIcons.xTwitter: {'color': const Color.fromARGB(255, 0, 0, 0), 'name': 'X'},
  FontAwesomeIcons.instagram: {'color': Colors.pinkAccent, 'name': 'Instagram'},
  FontAwesomeIcons.reddit: {'color': Colors.deepOrange, 'name': 'Reddit'},
  FontAwesomeIcons.snapchat: {'color': Colors.yellow, 'name': 'Snapchat'},
  FontAwesomeIcons.tumblr: {'color': Colors.blue, 'name': 'Tumblr'},
  FontAwesomeIcons.pinterest: {'color': Colors.red, 'name': 'Pinterest'},
  FontAwesomeIcons.telegram: {'color': Colors.blue, 'name': 'Telegram'},
  FontAwesomeIcons.whatsapp: {'color': Colors.green, 'name': 'WhatsApp'},
  FontAwesomeIcons.tiktok: {'color': Colors.black, 'name': 'TikTok'},
  FontAwesomeIcons.playstation: {'color': Colors.blue, 'name': 'Play Station'},

  // Servicios de Pago
  FontAwesomeIcons.paypal: {'color': Colors.indigo, 'name': 'PayPal'},
  FontAwesomeIcons.stripe: {'color': Colors.deepPurple, 'name': 'Stripe'},
  FontAwesomeIcons.applePay: {'color': Colors.black, 'name': 'Apple Pay'},
  FontAwesomeIcons.googlePay: {'color': Colors.blueAccent, 'name': 'Google Pay'},
  FontAwesomeIcons.shopify: {'color': Colors.green, 'name': 'Shopify'},
  FontAwesomeIcons.salesforce: {'color': Colors.lightBlue, 'name': 'Salesforce'},

  // Educación y Otros
  FontAwesomeIcons.linkedin: {'color': Colors.blue, 'name': 'LinkedIn Learning'},
  FontAwesomeIcons.medium: {'color': Colors.green, 'name': 'Medium'},
  FontAwesomeIcons.wordpress: {'color': Colors.indigo, 'name': 'WordPress'},

  // Otros
  FontAwesomeIcons.skype: {'color': Colors.lightBlue, 'name': 'Skype'},
  FontAwesomeIcons.dropbox: {'color': Colors.blue, 'name': 'Dropbox'},
  FontAwesomeIcons.wix: {'color': Colors.blueAccent, 'name': 'Wix'},
  FontAwesomeIcons.squarespace: {'color': Colors.black, 'name': 'Squarespace'},
  FontAwesomeIcons.amazonPay: {'color': Colors.black, 'name': 'Amazon Pay'},
};

  String _searchText = '';
  IconWithColor? _selectedIcon;

  void _onIconSelected(IconData icon) {
    setState(() {
      _selectedIcon = IconWithColor(
        icon,
        _iconsWithDetails[icon]!['color'],
      );
    });
    Navigator.pop(context, _selectedIcon);
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<IconData, Map<String, dynamic>>> filteredIcons =
        _iconsWithDetails.entries
            .where((entry) => entry.value['name']
                .toString()
                .toLowerCase()
                .contains(_searchText.toLowerCase()))
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
                final iconData = filteredIcons[index];
                return GestureDetector(
                  onTap: () {
                    _onIconSelected(iconData.key);
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          iconData.key,
                          size: 30,
                          color: iconData.value['color'],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          iconData.value['name'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
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
