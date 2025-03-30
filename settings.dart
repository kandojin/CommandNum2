import 'package:build/english/ehome.dart';
import 'package:build/kazakh/khome.dart';
import 'package:build/russian/rhome.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;
  bool soundsEnabled = false;
  String selectedLanguage = "en";

  void _showNotificationDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Notification settings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // Notifications Toggle
                  _buildSettingToggle(
                    title: "Notifications",
                    value: notificationsEnabled,
                    onChanged: (bool value) {
                      setStateDialog(() {
                        notificationsEnabled = value;
                        if (!value)
                          soundsEnabled =
                              false; // Disable sounds if notifications are off
                      });
                    },
                  ),
                  Divider(),

                  // Sounds Toggle (Disabled if notifications are off)
                  _buildSettingToggle(
                    title: "Sounds",
                    value: soundsEnabled,
                    onChanged:
                        notificationsEnabled
                            ? (bool value) {
                              setStateDialog(() {
                                soundsEnabled = value;
                              });
                            }
                            : null, // Disabled if notifications are off
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguageDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Change the language",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  _buildLanguageOption(
                    "Қазақ тілі",
                    "assets/kaz.png",
                    "kk",
                    setStateDialog,
                  ),
                  Divider(),
                  _buildLanguageOption(
                    "Русский",
                    "assets/rus.png",
                    "ru",
                    setStateDialog,
                  ),
                  Divider(),
                  _buildLanguageOption(
                    "English",
                    "assets/eng.png",
                    "en",
                    setStateDialog,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingToggle({
    required String title,
    required bool value,
    required Function(bool)? onChanged,
  }) {
    return GestureDetector(
      onTap:
          onChanged != null
              ? () => onChanged(!value)
              : null, // Make the entire row pressable
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color.fromARGB(255, 27, 78, 136),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    String title,
    String iconPath,
    String langCode,
    StateSetter setStateDialog,
  ) {
    return InkWell(
      onTap: () {
        setStateDialog(() {
          selectedLanguage = langCode;
        });
        setState(() {}); // Обновляем состояние в главном экране

        // Закрываем модальное окно
        Navigator.pop(context);

        // Переход на новый экран в зависимости от выбранного языка
        if (langCode == "ru") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RussianHomeScreen()),
          );
        } else if (langCode == "kk") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => KazakhHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EnglishHomeScreen()),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12, // Small circular icon
                backgroundImage: AssetImage(iconPath),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 10),
              Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
            ],
          ),
          Radio<String>(
            value: langCode,
            groupValue: selectedLanguage,
            activeColor: const Color.fromARGB(255, 27, 78, 136),
            onChanged: (value) {
              setStateDialog(() {
                selectedLanguage = value!;
              });
              setState(() {}); // Update main screen selection
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FC), // Background color
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMainButton(
              title: "Notificstion settings",
              value: "",
              onTap: _showNotificationDialog,
            ),

            SizedBox(height: 10),

            // Language Settings Button
            _buildMainButton(
              title: "Language",
              value: _getLanguageText(selectedLanguage),
              onTap: _showLanguageDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageText(String langCode) {
    switch (langCode) {
      case "kk":
        return "Қазақ тілі";
      case "ru":
        return "Русский";
      case "en":
        return "English";
      default:
        return "English";
    }
  }
}
