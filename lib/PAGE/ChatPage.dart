// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatMessage {
//   final String text;
//   final bool isUser;

//   ChatMessage({required this.text, this.isUser = false});

//   Map<String, dynamic> toJson() => {
//         'text': text,
//         'isUser': isUser,
//       };

//   factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
//         text: json['text'],
//         isUser: json['isUser'],
//       );
// }

// class ChatPage extends StatefulWidget {
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final List<ChatMessage> _messages = [];
//   final TextEditingController _controller = TextEditingController();
//   final String _apiUrl =
//       'http://127.0.0.1:8000/chat'; // use correct IP based on your device/emulator

//   @override
//   void initState() {
//     super.initState();
//     _loadChatHistory();
//   }

//   Future<void> _saveChatHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> jsonMessages =
//         _messages.map((message) => jsonEncode(message.toJson())).toList();
//     await prefs.setStringList('chat_history', jsonMessages);
//   }

//   Future<void> _loadChatHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? jsonMessages = prefs.getStringList('chat_history');
//     if (jsonMessages != null) {
//       setState(() {
//         _messages.clear();
//         _messages.addAll(
//           jsonMessages.map((msg) => ChatMessage.fromJson(jsonDecode(msg))),
//         );
//       });
//     }
//   }

//   Future<void> _sendMessage(String text) async {
//     if (text.isEmpty) return;
//     setState(() {
//       _messages.insert(0, ChatMessage(text: text, isUser: true));
//     });
//     _controller.clear();

//     // Save the message history
//     _saveChatHistory();

//     try {
//       final response = await http.post(
//         Uri.parse(_apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"message": text}),
//       );
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         String reply = data['reply'] ?? "No reply";
//         setState(() {
//           _messages.insert(0, ChatMessage(text: reply, isUser: false));
//         });
//       } else {
//         setState(() {
//           _messages.insert(
//               0,
//               ChatMessage(
//                   text: "Error: ${response.statusCode}", isUser: false));
//         });
//       }
//       _saveChatHistory();
//     } catch (e) {
//       setState(() {
//         _messages.insert(0, ChatMessage(text: "Error: $e", isUser: false));
//       });
//       _saveChatHistory();
//     }
//   }

//   Widget _buildMessage(ChatMessage message) {
//     return Container(
//       padding: message.isUser ? EdgeInsets.fromLTRB(80,8,8,8) : EdgeInsets.fromLTRB(8,8,80,8),
//       alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         decoration: BoxDecoration(
//           color: message.isUser ? Colors.blueAccent : Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
//         child: Text(
//           message.text,
//           style: TextStyle(color: message.isUser ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     //screen size
//     final Size size = MediaQuery.sizeOf(context);
//     //Screen width
//     double scrwidth = size.width;
//     //Screen hight
//     double scrheight = size.height;
//     print(scrheight);
//     print(scrwidth);
//     return Scaffold(
//       backgroundColor: Color.fromARGB(225, 7, 7, 27),
//       // appBar: AppBar(title: const Text("PDF Chat")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               itemCount: _messages.length,
//               itemBuilder: (context, index) => _buildMessage(_messages[index]),
//             ),
//           ),
//           Divider(height: 1.0),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     minLines: 1, // at least one line
//                     maxLines: 8, // expands as needed
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration.collapsed(
//                         hintText: "Type your message"),
//                     onSubmitted: _sendMessage,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () => _sendMessage(_controller.text),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final bool animate; // controls whether to animate the text

  ChatMessage({
    required this.text,
    this.isUser = false,
    this.animate = false,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'animate': animate,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        isUser: json['isUser'],
        animate: json['animate'] ?? false,
      );

  // Create a copy of the message with an updated animate property.
  ChatMessage copyWith({bool? animate}) {
    return ChatMessage(
      text: text,
      isUser: isUser,
      animate: animate ?? this.animate,
    );
  }
}

/// Widget that animates text letter-by-letter.
class TypingText extends StatefulWidget {
  final String fullText;
  final TextStyle? style;
  final Duration speed;
  final VoidCallback? onFinish;

  const TypingText({
    Key? key,
    required this.fullText,
    this.style,
    this.speed = const Duration(milliseconds: 50),
    this.onFinish,
  }) : super(key: key);

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayedText = "";
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant TypingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fullText != widget.fullText) {
      _resetAndType();
    }
  }

  void _resetAndType() {
    _timer?.cancel();
    setState(() {
      _displayedText = "";
      _currentIndex = 0;
    });
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.speed, (Timer timer) {
      if (_currentIndex < widget.fullText.length) {
        setState(() {
          _displayedText += widget.fullText[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
        // Notify that typing is complete.
        if (widget.onFinish != null) {
          widget.onFinish!();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  var url = dotenv.env['URL']! + "SignIn";
  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonMessages =
        _messages.map((message) => jsonEncode(message.toJson())).toList();
    await prefs.setStringList('chat_history', jsonMessages);
  }

  Future<void> _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonMessages = prefs.getStringList('chat_history');
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
    });
    _controller.clear();

    // Save the message history
    _saveChatHistory();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": text}),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String reply = data['reply'] ?? "No reply";
        setState(() {
          // Add agent message with animate: true so the typing effect is applied.
          _messages.insert(0, ChatMessage(text: reply, isUser: false, animate: true));
        });
      } else {
        setState(() {
          _messages.insert(
              0,
              ChatMessage(
                  text: "Error: ${response.statusCode}", isUser: false));
        });
      }
      _saveChatHistory();
    } catch (e) {
      setState(() {
        _messages.insert(0, ChatMessage(text: "Error: $e", isUser: false));
      });
      _saveChatHistory();
    }
  }

  Widget _buildMessage(ChatMessage message, int index) {
    // For agent messages, if it's the most recent (index == 0) and animate is true,
    // we show the TypingText widget. Otherwise, display plain text.
    bool showAnimation = !message.isUser && message.animate && index == 0;

    return Container(
      padding: message.isUser
          ? EdgeInsets.fromLTRB(80, 8, 8, 8)
          : EdgeInsets.fromLTRB(8, 8, 80, 8),
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        child: message.isUser
            ? Text(
                message.text,
                style: TextStyle(color: Colors.white),
              )
            : showAnimation
                ? TypingText(
                    fullText: message.text,
                    style: TextStyle(color: Colors.black),
                    speed: Duration(milliseconds: 20),
                    onFinish: () {
                      // Once the animation finishes, update the message to not animate.
                      setState(() {
                        _messages[0] = _messages[0].copyWith(animate: false);
                      });
                      _saveChatHistory();
                    },
                  )
                : Text(
                    message.text,
                    style: TextStyle(color: Colors.black),
                  ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Screen size
    final Size size = MediaQuery.sizeOf(context);
    double scrWidth = size.width;
    double scrHeight = size.height;
    print('Screen height: $scrHeight, width: $scrWidth');

    return Scaffold(
      backgroundColor: Color.fromARGB(225, 7, 7, 27),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  _buildMessage(_messages[index], index),
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
                    minLines: 1, // at least one line
                    maxLines: 8, // expands as needed
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

// void main() {
//   runApp(MaterialApp(
//     home: ChatPage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }


