import 'package:build/russian/menu/profile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class pChatListScreen extends StatefulWidget {
  @override
  _pChatListScreenState createState() => _pChatListScreenState();
}

class _pChatListScreenState extends State<pChatListScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ChatPage(),
    Center(child: Text("Статусы")),
    Center(child: Text("Звонки")),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chat,
                        color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(0),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.history,
                        color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(1),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.call,
                        color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(2),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.account_box,
                        color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(3),
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

class ChatPage extends StatelessWidget {
  final List<Map<String, String>> chats = [
    {"name": "Гражданин 1", "message": "Здравствуйте, у меня вопрос."},
    {"name": "Гражданин 2", "message": "Мне нужна помощь."},
    {"name": "Гражданин 3", "message": "Можно узнать детали по делу?"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(chats[index]['name']![10]), // "Гражданин X" -> X
          ),
          title: Text(chats[index]['name']!),
          subtitle: Text(chats[index]['message']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if (index == 0) {
                    return Citizen1Screen();
                  } else if (index == 1) {
                    return Citizen2Screen();
                  } else {
                    return Citizen3Screen();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

// Chat screens with AppBar for navigation
class Citizen1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Гражданин 1")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ChatBubble(text: "Здравствуйте, у меня вопрос.", isSender: false),
          ChatBubble(text: "Конечно, слушаю вас.", isSender: true),
          ChatBubble(text: "Как подать жалобу?", isSender: false),
          ChatBubble(
            text: "Вы можете подать заявление в участке или онлайн.",
            isSender: true,
          ),
        ],
      ),
    );
  }
}

class Citizen2Screen extends StatelessWidget {
  final double latitude = 49.806;
  final double longitude = 73.085; // Random coordinates in Karaganda

  void _openMap() async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Гражданин 2")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ChatBubble(text: "Мне нужна помощь.", isSender: false),
          GestureDetector(
            onTap: _openMap,
            child: ChatBubble(
              text: "📍 Моя локация ($latitude, $longitude)",
              isSender: false,
              isLink: true,
            ),
          ),
          ChatBubble(text: "Что случилось?", isSender: true),
          ChatBubble(
            text: "Меня преследует подозрительный человек.",
            isSender: false,
          ),
          ChatBubble(text: "Мы направляем патруль к вам.", isSender: true),
        ],
      ),
    );
  }
}

class Citizen3Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Гражданин 3")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ChatBubble(text: "Можно узнать детали по делу?", isSender: false),
          ChatBubble(
            text: "Конечно, какая информация вам нужна?",
            isSender: true,
          ),
          ChatBubble(text: "Какие улики были найдены?", isSender: false),
          ChatBubble(
            text: "Расследование еще идет, мы не можем раскрыть детали.",
            isSender: true,
          ),
        ],
      ),
    );
  }
}

// Chat Bubble Widget
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final bool isLink;

  ChatBubble({required this.text, required this.isSender, this.isLink = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSender ? Colors.white : Colors.black,
            decoration: isLink ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
