import 'package:flutter/material.dart';
import 'package:build/russian/message/gpt.dart';
import 'package:build/russian/message/message.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Чаты"),
        backgroundColor: const Color.fromARGB(255, 27, 78, 136),
      ),
      body: ListView(
        children: [
          _buildChatItem(
            context,
            name: "AI CHat",
            message: "Ожидайте патруль",
            time: "12:30",
            image: "assets/police.png",
            screen: const ChatScreen(name: '', chatName: ''),
          ),
          _buildChatItem(
            context,
            name: "Policeman",
            message: "Как я могу помочь?",
            time: "11:45",
            image: "assets/operator.png",
            screen: MessageScreen(initialMessage: ""),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required String name,
    required String message,
    required String time,
    required String image,
    required Widget screen,
  }) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(image), radius: 25),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(time, style: TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}
