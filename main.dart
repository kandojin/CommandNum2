import 'package:build/english/message/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:build/registr.dart';

import 'package:build/russian/police.dart';
import 'package:build/russian/police/pchatlist.dart';

import 'package:build/russian/rhome.dart';
import 'package:build/english/ehome.dart';
import 'package:build/kazakh/khome.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru'), Locale('kk')],
      path: 'assets/translations',
      fallbackLocale: Locale('ru'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('field'.tr(), style: _abduTextStyle(fontSize: 16)),
        ),
      );
    }

    try {
      final response = await http.post(
        Uri.parse('http://172.30.10.187:5000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final role = data['role'];

        var box = await Hive.openBox('userBox');
        await box.put('token', token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('success'.tr(), style: _abduTextStyle(fontSize: 16)),
          ),
        );

        // проверяем роль
        if (role == 'police') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => pChatListScreen()),
          );
        } else if (context.locale == Locale('en')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EnglishHomeScreen()),
          );
        } else if (context.locale == Locale('ru')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RussianHomeScreen()),
          );
        } else if (context.locale == Locale('kk')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KazakhHomeScreen()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('connection'.tr(), style: _abduTextStyle(fontSize: 16)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B4E88), Color.fromARGB(255, 27, 78, 136)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("welcome_text".tr(), style: _headerTextStyle()),
                Text("returning_user".tr(), style: _headerTextStyle()),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 100,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          "email".tr(),
                          Icons.email,
                          false,
                          _emailController,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          "password".tr(),
                          Icons.lock,
                          true,
                          _passwordController,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "login".tr(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "forgot_password".tr(),
                            style: _linkTextStyle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegistrScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "register".tr(),
                              style: _linkTextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PoliceScreen()),
                );
              },
              backgroundColor: Color(0xFF1B4E88),
              elevation: 0,
              child: Icon(Icons.local_police, size: 43, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: _buildLanguageDropdown(context),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ChatListScreen(), // Переход в чат с участковым
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Войти анонимно", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<Locale>(
          value: context.locale,
          underline: SizedBox(),
          dropdownColor: Colors.blueGrey,
          items: [
            DropdownMenuItem(
              value: Locale('en'),
              child: Text("English", style: TextStyle(color: Colors.white)),
            ),
            DropdownMenuItem(
              value: Locale('ru'),
              child: Text("Русский", style: TextStyle(color: Colors.white)),
            ),
            DropdownMenuItem(
              value: Locale('kk'),
              child: Text("Қазақша", style: TextStyle(color: Colors.white)),
            ),
          ],
          onChanged: (newLocale) {
            context.setLocale(newLocale!);
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon,
    bool isPassword,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 27, 78, 136)),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  TextStyle _headerTextStyle() =>
      TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white);

  TextStyle _linkTextStyle({double fontSize = 15}) =>
      TextStyle(fontSize: fontSize, color: Color.fromARGB(255, 27, 78, 136));
  TextStyle _abduTextStyle({double fontSize = 15}) =>
      TextStyle(fontSize: fontSize, color: Colors.white);
}
