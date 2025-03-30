import 'package:build/main.dart';
import 'package:build/english/menu/priper.dart';
import 'package:build/english/message/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:build/english/ehome.dart';
// ignore: unused_import
import 'package:build/english/message/message.dart';
import 'package:build/english/map.dart';
//MenuScreen imports
import 'package:build/english/menu/aboutapp.dart';
import 'package:build/english/menu/support.dart';
import 'package:build/english/menu/profile.dart';
import 'package:build/english/menu/settings.dart';
import 'package:build/english/menu/history.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCity = "Karaganda";
  void _onItemTapped(int index) {
    setState(() {});
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
              : Image.asset(icon, width: 30, height: 30, color: Colors.white),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FC),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 50),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 25), // Отступ снизу
            decoration: BoxDecoration(
              color: Colors.white, // Белый фон
              borderRadius: BorderRadius.circular(20), // Закругленные края
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(51),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Тень вниз
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Image.asset(
                    "assets/menu_icon.png",
                    width: 80,
                    height: 80,
                  ), // Иконка
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "+7 776 --- -- 50",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.verified,
                          color: const Color.fromARGB(255, 27, 78, 136),
                          size: 18,
                        ), // Синяя галочка
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Карточка с настройками (все пункты внутри одного контейнера)
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 4,
            ), // Уменьшил внутренние отступы
            margin: EdgeInsets.only(
              bottom: 25,
            ), // Уменьшил расстояние между контейнерами
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                15,
              ), // Можно немного уменьшить скругление
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(51),
                  spreadRadius: 1, // Сделал тень слабее
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(Icons.person, "Profile"),
                Divider(height: 10), // Уменьшил разделитель
                _buildMenuItem(
                  Icons.location_on,
                  "City",
                  trailingText: selectedCity,
                ),
                Divider(height: 10),
                _buildMenuItem(Icons.security, "Security"),
                Divider(height: 10),
                _buildMenuItem(Icons.settings, "Settings"),
                Divider(height: 10),
                _buildMenuItem(Icons.history, "History"),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 4,
            ), // Уменьшил отступы внутри
            margin: EdgeInsets.only(
              bottom: 25,
            ), // Уменьшил расстояние между контейнерами
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                15,
              ), // Сделал скругление углов меньше
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(51),
                  spreadRadius: 1, // Ослабил тень
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(Icons.help_outline, "Help"),
                Divider(height: 10), // Уменьшил разделитель
                _buildMenuItem(Icons.info_outline, "About app"),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 4), // Меньше отступ
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                12,
              ), // Меньше скругление углов
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(30), // Ослабляем тень
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [_buildMenuItem(Icons.exit_to_app, "Выйти")],
            ),
          ),
        ],
      ),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatListScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 80),
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
                    onTap: () => _onItemTapped(3),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 35,
            left: MediaQuery.of(context).size.width / 2 - 35, // Центрируем
            child: GestureDetector(
              onTap: () {
                print("SOS!");
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

  Widget _buildMenuItem(IconData icon, String title, {String? trailingText}) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          if (title == "Выйти") {
            _showExitDialog();
          } else if (title == "About app") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutAppScreen()),
            );
          } else if (title == "Help") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SupportScreen()),
            );
          } else if (title == "City") {
            _showCityDialog();
          } else if (title == "Profile") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          } else if (title == "Settings") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          } else if (title == "History") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );
          } else if (title == "Security") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecurityScreen()),
            );
          }
        },
        splashColor: Colors.blueGrey.withOpacity(0.3), // Волна при нажатии
        highlightColor: Colors.blueGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: const Color.fromARGB(255, 27, 78, 136)),
              SizedBox(width: 12),
              Expanded(child: Text(title, style: TextStyle(fontSize: 16))),
              if (trailingText != null)
                Text(
                  trailingText,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              if (trailingText == null)
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showCityDialog() {
    List<String> cities = [
      "Almaty",
      "Karaganda",
      "Astana",
      "Saran",
      "Balkhash",
      "Temirtau",
      "Taldykorgan",
      "Ust-Kamenogorsk",
    ];
    String tempSelectedCity = selectedCity;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select city",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: cities.length,
                    separatorBuilder:
                        (context, index) => Divider(color: Colors.grey),
                    itemBuilder: (context, index) {
                      String city = cities[index];
                      return RadioListTile<String>(
                        title: Text(city, style: TextStyle(fontSize: 20)),
                        value: city,
                        groupValue: tempSelectedCity,
                        activeColor: const Color.fromARGB(
                          255,
                          27,
                          78,
                          136,
                        ), // Жёлтый цвет, как на картинке
                        onChanged: (value) {
                          setStateDialog(() {
                            tempSelectedCity = value!;
                          });
                        },
                        visualDensity: VisualDensity(
                          horizontal: -4,
                        ), // Уменьшаем расстояние
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0,
                        ), // Убираем лишний отступ
                      );
                    },
                  ),

                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCity = tempSelectedCity;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                        255,
                        27,
                        78,
                        136,
                      ), // Жёлтая кнопка
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Select", style: TextStyle(fontSize: 18)),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit"),
          content: Text("Are you sure that you want to close?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Закрыть диалог
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("Выйти", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
