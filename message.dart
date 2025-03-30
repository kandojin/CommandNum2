import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

class MessageScreen extends StatefulWidget {
  final String initialMessage;

  const MessageScreen({super.key, required this.initialMessage});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage.isNotEmpty) {
      _messages.insert(0, widget.initialMessage);
      _sendMessage(widget.initialMessage);
    }
  }

  void _sendMessage(String? customText) {
    final text = customText ?? _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        _messages.insert(0, text);
        _controller.clear();
      });

      // TODO: здесь отправка на сервер, как ты делаешь через /send-message
      print("Отправлено: $text");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Чат", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 27, 78, 136),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 27, 78, 136),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _messages[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Введите сообщение...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 27, 78, 136),
                  ),
                  onPressed: () => _sendMessage(null),
                  color: const Color.fromARGB(255, 27, 78, 136),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
