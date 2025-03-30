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

class RussianHomeScreen extends StatefulWidget {
  const RussianHomeScreen({super.key});

  @override
  State<RussianHomeScreen> createState() => _RussianHomeScreenState();
}

class _RussianHomeScreenState extends State<RussianHomeScreen> {
  final List<Map<String, String>> newsList = [
    {
      "title": "Карагандинские полицейские задержали «степного угонщика»",
      "description":
          "У 38-летнего жителя Бухар-Жырауского района в степи украли мотоцикл. Неизвестный похитил «железного коня» еще осенью. А потерпевший обратился в полицию только через четыре месяца. Ущерб составил 700 тысяч тенге.",
      "image": "assets/news/news1.png",
      "link":
          "https://www.inkaragandy.kz/news/3922756/karagandinskie-policejskie-zaderzali-stepnogo-ugonsika",
    },
    {
      "title":
          "В Карагандинской области пресекли хищение почти на 500 млн тенге",
      "description":
          "Известно, что в период с 2021 по 2023 год РГП и его территориальный филиал заключили 23 договора с единственным источником на поставку кожевенного и трикотажного сырья для производства одежды и обуви.",
      "image": "assets/news/news2.png",
      "link":
          "https://www.inkaragandy.kz/news/3919100/v-karagandinskoj-oblasti-presekli-hisenie-pocti-na-500-mln-tenge",
    },
    {
      "title":
          "В Карагандинской области задержан мужчина, покупавший девушек для сексуальных утех",
      "description":
          "За три дня проведения мероприятия полицейские выявили 40 подобных преступлений. Также зафиксировано 156 административных правонарушений за предоставление помещений для сводничества и 640 случаев приставания в общественных местах.",
      "image": "assets/news/news3.png",
      "link":
          "https://www.inkaragandy.kz/news/3918397/v-karagandinskoj-oblasti-zaderzan-muzcina-vykupavsij-devocek-dla-seksualnyh-uteh",
    },
    {
      "title": "Казахстанцев предупреждают о мошенничестве через Telegram",
      "description":
          "По информации прокуратуры Алматинской области, в мессенджере Telegram взламывают аккаунты и рассылают всем контактам различные сообщения со ссылками.",
      "image": "assets/news/news4.png",
      "link":
          "https://www.inkaragandy.kz/news/3917373/kazahstancev-preduprezdaut-o-mosennicestve-cerez-telegram",
    },
    {
      "title":
          "После свадьбы 15-летней девочки в Карагандинской области возбуждено уголовное дело",
      "description":
          "По данным ведомства, заявление поступило в полицию 15 марта. В тот же день было возбуждено уголовное дело, подозреваемый задержан и помещен в изолятор временного содержания.",
      "image": "assets/news/news5.png",
      "link":
          "https://www.inkaragandy.kz/news/3917366/ugolovnoe-delo-vozbuzdeno-posle-zenitby-15-letnej-devocki-v-karagandinskoj-oblasti",
    },
    {
      "title":
          "Мошенники через WhatsApp обманули жителя Карагандинской области",
      "description":
          "11 марта в отдел полиции Аккольского района поступило заявление от местного жителя о мошенничестве. Мужчина сообщил, что 6 марта «знакомый» попросил в долг 280 тысяч тенге через WhatsApp. Он перевел указанную сумму на предоставленный счет.",
      "image": "assets/news/news6.png",
      "link":
          "https://www.inkaragandy.kz/news/3916432/mosenniki-cerez-whatsapp-obmanuli-zitela-karagandinskoj-oblasti",
    },
    {
      "title": "В Темиртау задержан мужчина, подозреваемый в убийстве",
      "description":
          "На данный момент известно, что задержан 27-летний мужчина, подозреваемый в убийстве. Он помещен в изолятор временного содержания.",
      "image": "assets/news/news7.png",
      "link":
          "https://www.inkaragandy.kz/news/3914528/v-temirtau-zaderzan-muzcina-podozrevaemyj-v-ubijstve",
    },
    {
      "title": "В Карагандинской области раскрыли квартирную кражу",
      "description":
          "Вор не оставил даже украшений. Жительница деревни оценила ущерб в 800 тысяч тенге. В рамках уголовного расследования полицейские задержали 34-летнего мужчину. Он полностью признал свою вину и вернул похищенное имущество в виде залоговых билетов ломбарда.",
      "image": "assets/news/news8.png",
      "link":
          "https://www.inkaragandy.kz/news/3912865/kvartirnuu-krazu-raskryli-v-karagandinskoj-oblasti",
    },
    {
      "title": "Мошенники украли у казахстанца 1,5 миллиона тенге через TikTok",
      "description":
          "Жительница Туркестанской области в своем видеообращении выразила искреннюю благодарность следователю Сарыагашского районного отдела полиции Нургали Абсену за помощь в расследовании мошенничества.",
      "image": "assets/news/news9.png",
      "link":
          "https://www.inkaragandy.kz/news/3908704/15-mln-tenge-ukrali-mosenniki-u-kazahstanca-v-tiktok",
    },
    {
      "title": "В Карагандинской области полиция раскрыла автокражу",
      "description":
          "У 46-летнего жителя региона украли мобильный телефон из автомобиля.",
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
        "🚨 SOS: Мои координаты: ${position.latitude}, ${position.longitude}";

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
        print('SOS успешно отправлен');
      } else {
        print('Ошибка SOS: ${response.body}');
      }
    } catch (e) {
      print('Ошибка сети: $e');
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
        title: const Text("Новостная лента"),
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
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    newsList[index]["description"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 206, 206, 206),
                    ),
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
                            content: Text("Не удалось открыть ссылку"),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      width: 110,
                      height: 30,
                      child: const Text(
                        "Подробнее...",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 168, 219),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
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
                    label: "Главная",
                    onTap: () => _onItemTapped(0),
                  ),
                  _buildNavItem(
                    icon: Icons.message,
                    label: "Сообщении",
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
                    label: "Карта",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.dehaze,
                    label: "Меню",
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
