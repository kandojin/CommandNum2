import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:build/russian/consts.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required String name, required String chatName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final OpenAI _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 20), // Увеличенный таймаут
    ),
    enableLog: true,
  );

  final ChatUser _currentUser = ChatUser(
    id: "1",
    firstName: "Ahmet",
    lastName: "Adilikhan",
  );
  final ChatUser _gptChatUser = ChatUser(
    id: "2",
    firstName: "Chat",
    lastName: "GPT",
  );

  // ignore: prefer_final_fields
  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 27, 78, 136),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset("assets/gos-gerb.png", height: 40, width: 40),
          ),
        ],
      ),
      body: DashChat(
        currentUser: _currentUser,
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.blueAccent,
          containerColor: const Color.fromARGB(255, 177, 177, 177),
          textColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        onSend: (ChatMessage message) => getChatResponse(message),
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
    });

    List<Map<String, dynamic>> messagesHistory =
        _messages.reversed.map((msg) {
          return {
            "role": msg.user.id == _currentUser.id ? "user" : "assistant",
            "content": msg.text,
          };
        }).toList();

    final request = ChatCompleteText(
      model: GptTurboChatModel(),
      messages: messagesHistory, // Передаем список карт (Map<String, dynamic>)
      maxToken: 200,
    );

    try {
      final response = await _openAI.onChatCompletion(request: request);

      if (response != null && response.choices.isNotEmpty) {
        final chatMessage = response.choices.first.message?.content.trim();

        if (chatMessage != null && chatMessage.isNotEmpty) {
          setState(() {
            _messages.insert(
              0,
              ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: chatMessage,
              ),
            );
          });
        } else {
          throw Exception("Пустой ответ от AI");
        }
      } else {
        throw Exception("Ответ от AI отсутствует");
      }
    } catch (e) {
      debugPrint("Ошибка OpenAI API: $e");
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _gptChatUser,
            createdAt: DateTime.now(),
            text: "Ошибка при обработке запроса. Попробуйте снова.",
          ),
        );
      });
    }
  }
}
