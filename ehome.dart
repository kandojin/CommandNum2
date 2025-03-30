import 'package:flutter/material.dart';
import 'package:build/english/menu/menu.dart';
import 'package:build/english/map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:build/english/message/message.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

class EnglishHomeScreen extends StatefulWidget {
  const EnglishHomeScreen({super.key});

  @override
  State<EnglishHomeScreen> createState() => _EnglishHomeScreenState();
}

class _EnglishHomeScreenState extends State<EnglishHomeScreen> {
  final List<Map<String, String>> newsList = [
    {
      "title": "Karaganda police detained \"steppe hijacker",
      "description":
          "A motorcycle was stolen from a 38-year-old resident of Bukhar-Zhyrau district in the steppe. An unknown person stole the \“iron horse\" last fall. And the victim contacted the police only after four months. The damage amounted to 700 thousand tenge.",
      "image": "assets/news/news1.png",
      "link":
          "https://www.inkaragandy.kz/news/3922756/karagandinskie-policejskie-zaderzali-stepnogo-ugonsika ",
    },
    {
      "title":
          "Theft of almost 500 million tenge was stopped in Karaganda region",
      "description":
          "It is known that in the period from 2021 to 2023, the RSE and its territorial branch concluded 23 single-source contracts for the supply of leather and knitted raw materials for the production of clothing and footwear.",
      "image": "assets/news/news2.png",
      "link":
          "https://www.inkaragandy.kz/news/3919100/v-karagandinskoj-oblasti-presekli-hisenie-pocti-na-500-mln-tenge",
    },
    {
      "title":
          "A man who bought girls for sexual pleasures was detained in the Karaganda region",
      "description":
          "During the three days of the event, the police revealed 40 such crimes. There were also 156 administrative offenses for providing premises for pandering and 640 for harassment in public places.",
      "image": "assets/news/news3.png",
      "link":
          "https://www.inkaragandy.kz/news/3918397/v-karagandinskoj-oblasti-zaderzan-muzcina-vykupavsij-devocek-dla-seksualnyh-uteh",
    },
    {
      "title": "Kazakhstanis are being warned about fraud via Telegram",
      "description":
          "According to the information of the Prosecutor's office of the Almaty region, accounts are hacked in the Telegram messenger and messages are sent to all contacts of a different nature with a link.",
      "image": "assets/news/news4.png",
      "link":
          "https://www.inkaragandy.kz/news/3917373/kazahstancev-preduprezdaut-o-mosennicestve-cerez-telegram ",
    },
    {
      "title":
          "A criminal case was initiated after the marriage of a 15-year-old girl in the Karaganda region",
      "description":
          "According to the agency, the statement was received by the police on March 15. On the same day, a criminal case was opened, and the suspect was detained and placed in a temporary detention facility.",
      "image": "assets/news/news5.png",
      "link":
          "https://www.inkaragandy.kz/news/3917366/ugolovnoe-delo-vozbuzdeno-posle-zenitby-15-letnej-devocki-v-karagandinskoj-oblasti",
    },
    {
      "title": "Scammers deceived a resident of Karaganda region via WhatsApp",
      "description":
          "On March 11, the Akkol district police department received a statement from a local resident about fraud. The man said that on March 6, an \“acquaintance\" asked to borrow 280 thousand tenge via WhatsApp. He transferred the specified amount to the provided account.",
      "image": "assets/news/news6.png",
      "link":
          "https://www.inkaragandy.kz/news/3916432/mosenniki-cerez-whatsapp-obmanuli-zitela-karagandinskoj-oblasti ",
    },
    {
      "title": "A man suspected of murder was detained in Temirtau",
      "description":
          "At the moment, it is known that the suspect, a man aged 27, has been detained. He has been placed in a temporary detention facility.",
      "image": "assets/news/news7.png",
      "link":
          "https://www.inkaragandy.kz/news/3914528/v-temirtau-zaderzan-muzcina-podozrevaemyj-v-ubijstve",
    },
    {
      "title": "Apartment theft uncovered in Karaganda region",
      "description":
          "The thief didn't even leave any jewelry. The villager estimated the damage at 800 thousand tenge. As part of the criminal investigation into the theft, the police detained a 34-year-old villager. The man fully admitted his guilt and returned the stolen property in the form of pawnshop security tickets.",
      "image": "assets/news/news8.png",
      "link":
          "https://www.inkaragandy.kz/news/3912865/kvartirnuu-krazu-raskryli-v-karagandinskoj-oblasti",
    },
    {
      "title":
          "1.5 million tenge was stolen by scammers from a Kazakhstani on TikTok",
      "description":
          "A resident of the Turkestan region in her video message expressed her sincere gratitude to the investigator of the Saryagash district police department Nurgali Absen for his assistance in investigating fraud.",
      "image": "assets/news/news9.png",
      "link":
          "https://www.inkaragandy.kz/news/3908704/15-mln-tenge-ukrali-mosenniki-u-kazahstanca-v-tiktok ",
    },
    {
      "title": "Car theft uncovered by police in Karaganda region",
      "description":
          "A 46-year-old resident of the region had his mobile phone stolen from his car.",
      "image": "assets/news/news10.png",
      "link":
          "https://www.inkaragandy.kz/news/3908508/avtokraza-raskryta-policiej-v-karagandinskoj-oblasti",
    },
  ];

  void _onItemTapped(int index) {
    setState(() {});
  }

  Future<void> _sendSOS(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    var box = await Hive.openBox('userBox');
    final token = box.get('token');

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Geolocation services were disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Geolocation permissions denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Geolocation is permanently prohibited.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String message =
        "🚨 SOS: My coordinates: ${position.latitude}, ${position.longitude}";

    try {
      final response = await http.post(
        Uri.parse('http://172.30.10.187:5000/sos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "latitude": position.latitude,
          "longitude": position.longitude,
        }),
      );

      if (response.statusCode == 200) {
        print('SOS was sent successfully');
      } else {
        print('SOS error: ${response.body}');
      }
    } catch (e) {
      print('Network error: $e');
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MessageScreen(initialMessage: message)),
    );
  }

  Widget _buildNavItem({
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon is IconData
              ? Icon(icon, color: Colors.white, size: 30)
              : Image.asset(icon, width: 30, height: 30),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News feed"),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 27, 78, 136),
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color.fromARGB(255, 56, 89, 179),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      newsList[index]["image"]!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    newsList[index]["title"]!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    newsList[index]["description"]!,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(newsList[index]["link"]!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Couldn't open the link"),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "More...",
                      style: TextStyle(
                        color: Color.fromARGB(255, 4, 33, 67),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      /// Закругленный BottomAppBar
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: const Color.fromARGB(255, 27, 78, 136),
            notchMargin: 8,
            elevation: 10,
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home,
                    label: "Home",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnglishHomeScreen(),
                        ),
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.message,
                    label: "Message",
                    onTap: () => _onItemTapped(1),
                  ),
                  SizedBox(width: 80), // Оставляем место для кнопки
                  _buildNavItem(
                    icon: Icons.map,
                    label: "Map",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.dehaze,
                    label: "Menu",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// QR-кнопка (замена FloatingActionButton)
          Positioned(
            bottom: 35, // Поднимаем кнопку над BottomAppBar
            left: MediaQuery.of(context).size.width / 2 - 35, // Центрируем
            child: GestureDetector(
              onTap: () {
                _sendSOS(context);
              },

              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/sos.png"),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
