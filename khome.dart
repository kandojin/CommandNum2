import 'package:flutter/material.dart';
import 'package:build/russian/menu/menu.dart';
import 'package:build/russian/map.dart';
import 'package:build/russian/message/chats_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:build/russian/message/message.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

class KazakhHomeScreen extends StatefulWidget {
  const KazakhHomeScreen({super.key});

  @override
  State<KazakhHomeScreen> createState() => _KazakhHomeScreenState();
}

class _KazakhHomeScreenState extends State<KazakhHomeScreen> {
  final List<Map<String, String>> newsList = [
    {
      "title": "Қарағанды полицейлері «дала ұрысын» ұстады",
      "description":
          "Бұқар-Жырау ауданының 38 жастағы тұрғынының мотоциклін далада ұрлап кеткен. Белгісіз адам «темір тұлпарды» өткен күзде айдап әкеткен. Ал жәбірленуші төрт айдан кейін ғана полицияға жүгінген. Шығын 700 мың теңгені құрады.",
      "image": "assets/news/news1.png",
      "link":
          "https://www.inkaragandy.kz/news/3922756/karagandinskie-policejskie-zaderzali-stepnogo-ugonsika",
    },
    {
      "title": "Қарағанды облысында 500 млн теңгеге жуық ұрлықтың жолы кесілді",
      "description":
          "2021 жылдан 2023 жылға дейін РМК мен оның аумақтық филиалы киім мен аяқ киім өндіру үшін былғары және тоқыма шикізатын жеткізуге 23 бір көзден сатып алу келісімшартын жасағаны белгілі болды.",
      "image": "assets/news/news2.png",
      "link":
          "https://www.inkaragandy.kz/news/3919100/v-karagandinskoj-oblasti-presekli-hisenie-pocti-na-500-mln-tenge",
    },
    {
      "title":
          "Қарағанды облысында жезөкшелік үшін қыздарды сатып алған ер адам ұсталды",
      "description":
          "Үш күн ішінде полиция осындай 40 қылмысты анықтады. Сондай-ақ, жеңгетайлыққа орын бергені үшін 156 әкімшілік құқық бұзушылық және қоғамдық орындарда тиісу бойынша 640 құқық бұзушылық тіркелді.",
      "image": "assets/news/news3.png",
      "link":
          "https://www.inkaragandy.kz/news/3918397/v-karagandinskoj-oblasti-zaderzan-muzcina-vykupavsij-devocek-dla-seksualnyh-uteh",
    },
    {
      "title": "Қазақтарды Telegram арқылы алаяқтықтан сақтандыруда",
      "description":
          "Алматы облысының прокуратурасының мәліметінше, Telegram мессенджеріндегі аккаунттар бұзылып, барлық контактілерге әртүрлі мазмұндағы сілтемелер жіберіледі.",
      "image": "assets/news/news4.png",
      "link":
          "https://www.inkaragandy.kz/news/3917373/kazahstancev-preduprezdaut-o-mosennicestve-cerez-telegram",
    },
    {
      "title":
          "Қарағанды облысында 15 жасар қыздың некесінен кейін қылмыстық іс қозғалды",
      "description":
          "Ведомствоның мәліметінше, полицияға арыз 15 наурызда түскен. Сол күні қылмыстық іс қозғалып, күдікті ұсталып, уақытша ұстау изоляторына қамалды.",
      "image": "assets/news/news5.png",
      "link":
          "https://www.inkaragandy.kz/news/3917366/ugolovnoe-delo-vozbuzdeno-posle-zenitby-15-letnej-devocki-v-karagandinskoj-oblasti",
    },
    {
      "title":
          "Қарағанды облысының тұрғынын WhatsApp арқылы алаяқтар алдап кетті",
      "description":
          "11 наурызда Ақкөл аудандық полиция бөлімшесіне жергілікті тұрғыннан алаяқтық туралы шағым түсті. Ер адам 6 наурызда «танысы» WhatsApp арқылы 280 мың теңге қарыз сұрағанын айтты. Ол көрсетілген шотқа қаражат аударған.",
      "image": "assets/news/news6.png",
      "link":
          "https://www.inkaragandy.kz/news/3916432/mosenniki-cerez-whatsapp-obmanuli-zitela-karagandinskoj-oblasti",
    },
    {
      "title": "Теміртауда кісі өлтірді деген күдікпен ер адам ұсталды",
      "description":
          "Қазіргі уақытта күдікті 27 жастағы ер адамның ұсталғаны белгілі. Ол уақытша ұстау изоляторына қамалды.",
      "image": "assets/news/news7.png",
      "link":
          "https://www.inkaragandy.kz/news/3914528/v-temirtau-zaderzan-muzcina-podozrevaemyj-v-ubijstve",
    },
    {
      "title": "Қарағанды облысында пәтер ұрлығы ашылды",
      "description":
          "Ұры тіпті әшекейлерді де қалдырмаған. Ауыл тұрғыны шығынды 800 мың теңгеге бағалады. Қылмыстық тергеу аясында полиция 34 жастағы ауыл тұрғынын ұстады. Ол кінәсін толық мойындап, ұрланған заттарды ломбардтағы кепіл билеттері түрінде қайтарды.",
      "image": "assets/news/news8.png",
      "link":
          "https://www.inkaragandy.kz/news/3912865/kvartirnuu-krazu-raskryli-v-karagandinskoj-oblasti",
    },
    {
      "title":
          "TikTok арқылы алаяқтар қазақстандықтан 1,5 миллион теңге ұрлады",
      "description":
          "Түркістан облысының тұрғыны өз бейнеүндеуінде Сарыағаш аудандық полиция бөлімінің тергеушісі Нұрғали Абсенге алаяқтықты тергеуге көмектескені үшін шынайы алғысын білдірді.",
      "image": "assets/news/news9.png",
      "link":
          "https://www.inkaragandy.kz/news/3908704/15-mln-tenge-ukrali-mosenniki-u-kazahstanca-v-tiktok",
    },
    {
      "title": "Қарағанды облысында автокөлік ұрлығы ашылды",
      "description":
          "Өңірдің 46 жастағы тұрғынының көлігінен ұялы телефоны ұрланған.",
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
      print('Службы геолокации отключены.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Разрешение на геолокацию отклонено');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Геолокация запрещена навсегда.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String message =
        "🚨 SOS: Менің координаттарым: ${position.latitude}, ${position.longitude}";

    // Отправим в бэкенд SOS
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
        print('SOS сәтті жіберілді');
      } else {
        print('Қате SOS: ${response.body}');
      }
    } catch (e) {
      print('Желі қатесі: $e');
    }

    // Открываем чат с сообщением
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
        title: const Text("Жаңалықтар арнасы"),
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
                            content: Text("Сілтемені ашу мүмкін болмады"),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Толығырақ...",
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
                          builder: (context) => KazakhHomeScreen(),
                        ),
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.message,
                    label: "Message",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatListScreen(),
                        ),
                      );
                    },
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
