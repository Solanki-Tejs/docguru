import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, this.isUser = false});

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        isUser: json['isUser'],
      );
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final String _apiUrl = 'http://127.0.0.1:8000/chat'; // Adjust if needed

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<String> _getChatHistoryKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "default";
    return "chat_history_$token";
  }

  Future<void> _saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = await _getChatHistoryKey();
    List<String> jsonMessages =
        _messages.map((message) => jsonEncode(message.toJson())).toList();
    await prefs.setStringList(key, jsonMessages);
  }

  Future<void> _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = await _getChatHistoryKey();
    List<String>? jsonMessages = prefs.getStringList(key);
    if (jsonMessages != null) {
      setState(() {
        _messages.clear();
        _messages.addAll(
          jsonMessages.map((msg) => ChatMessage.fromJson(jsonDecode(msg))),
        );
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true));
      _messages.insert(0, ChatMessage(text: "", isUser: false)); // Empty bot response placeholder
    });
    _controller.clear();
    _saveChatHistory();

    final startTime = DateTime.now();

    try {
      final request = http.Request("POST", Uri.parse(_apiUrl));
      request.headers["Content-Type"] = "application/json";
      request.body = jsonEncode({"message": text});

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        String reply = "";
        int botMessageIndex = 0;

        // Transform response stream to listen to the response as characters
        response.stream.transform(utf8.decoder).listen((chunk) {
          for (int i = 0; i < chunk.length; i++) {
            reply += chunk[i];  // Append each character

            // Delay the update for each letter
            Future.delayed(Duration(milliseconds: 50 * (i + 1)), () {
              setState(() {
                _messages[botMessageIndex] = ChatMessage(text: reply, isUser: false);
              });
            });
          }
        }, onDone: () {
          final elapsed = DateTime.now().difference(startTime);
          setState(() {
            _messages[botMessageIndex] = ChatMessage(
                text: "${_messages[botMessageIndex].text}\n\nResponse Time: ${elapsed.inMilliseconds} ms",
                isUser: false);
          });
          _saveChatHistory();
        });
      } else {
        setState(() {
          _messages.insert(
              0, ChatMessage(text: "Error: ${response.statusCode}", isUser: false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.insert(0, ChatMessage(text: "Error: $e", isUser: false));
      });
    }
    _saveChatHistory();
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      padding: EdgeInsets.all(8.0),
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        child: Text(
          message.text,
          style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(225, 7, 7, 27),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  _buildMessage(_messages[index]),
            ),
          ),
          Divider(height: 1.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 8,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration.collapsed(
                      hintText: "Type your message",
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () => _sendMessage(_controller.text),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
