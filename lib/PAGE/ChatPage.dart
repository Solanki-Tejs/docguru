// import 'dart:convert';
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
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
//   final String _apiUrl = dotenv.env['URL']! + "chat"; // Adjust IP/port if needed

//   @override
//   void initState() {
//     super.initState();
//     _loadChatHistory();
//   }

//   /// Returns a key for the chat history based on the current account's token.
//   Future<String> _getChatHistoryKey() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // Token should be set at login; if missing, default is used.
//     String token = prefs.getString("token") ?? "default";
//     return "chat_history_$token";
//   }

//   Future<void> _saveChatHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String key = await _getChatHistoryKey();
//     List<String> jsonMessages =
//         _messages.map((message) => jsonEncode(message.toJson())).toList();
//     await prefs.setStringList(key, jsonMessages);
//   }

//   Future<void> _loadChatHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String key = await _getChatHistoryKey();
//     List<String>? jsonMessages = prefs.getStringList(key);
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

//     // Insert user message.
//     setState(() {
//       _messages.insert(0, ChatMessage(text: text, isUser: true));
//     });
//     _controller.clear();
//     _saveChatHistory();

//     // Start timer to measure response time.
//     final startTime = DateTime.now();

//     try {
//       final request = http.Request("POST", Uri.parse(_apiUrl));
//       request.headers["Content-Type"] = "application/json";
//       request.body = jsonEncode({"message": text});

//       final response = await http.Client().send(request);

//       if (response.statusCode == 200) {
//         String reply = "";
//         // Listen to the stream and update the UI as data arrives.
//         response.stream.transform(utf8.decoder).listen((chunk) {
//            print("Received chunk: $chunk");
//           setState(() {
//             reply += chunk;
//             // If there's no previous bot reply, insert one.
//             if (_messages.isEmpty || _messages.first.isUser) {
//               _messages.insert(0, ChatMessage(text: reply, isUser: false));
//             } else {
//               // Update the existing bot message.
//               _messages[0] = ChatMessage(text: reply, isUser: false);
//             }
//           });
//         }, onDone: () {
//           print("Stream finished");
//           // Calculate elapsed time when the stream is finished.
//           final elapsed = DateTime.now().difference(startTime);
//           setState(() {
//             // Append response time to the end of the message.
//             String finalText =
//                 "${_messages[0].text}\n\nResponse Time: ${elapsed.inMilliseconds} ms";
//             _messages[0] = ChatMessage(text: finalText, isUser: false);
//           });
//           _saveChatHistory();
//         });
//       } else {
//         setState(() {
//           _messages.insert(
//               0, ChatMessage(text: "Error: ${response.statusCode}", isUser: false));
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _messages.insert(0, ChatMessage(text: "Error: $e", isUser: false));
//       });
//     }
//     _saveChatHistory();
//   }

//   Widget _buildMessage(ChatMessage message) {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       alignment:
//           message.isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         decoration: BoxDecoration(
//           color: message.isUser ? Colors.blueAccent : Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
//         child: Text(
//           message.text,
//           style: TextStyle(
//               color: message.isUser ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        backgroundColor: Color.fromARGB(225, 7, 7, 27),
//       // appBar: AppBar(title: const Text("PDF Chat")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               itemCount: _messages.length,
//               itemBuilder: (context, index) =>
//                   _buildMessage(_messages[index]),
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
//                     minLines: 1,
//                     maxLines: 8,
//                      style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration.collapsed(
//                         hintText: "Type your message",
//                         hintStyle: TextStyle(color: Colors.white70),),
//                     onSubmitted: _sendMessage,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send,color: Colors.white),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final int pageIndex;
  final List<String> messages; // Holds chat messages for this specific page
  final Function(List<String>)
      onMessagesUpdated; // Callback to update parent state

  const ChatPage({
    super.key,
    required this.pageIndex,
    required this.messages,
    required this.onMessagesUpdated,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  // Function to send the chat message to the backend
  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      widget.messages.add("You: $message"); // Add user's message
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var collactionName =
        prefs.getString('CollactionNames_${widget.pageIndex}_name');
    print(collactionName);
    // Send the message to FastAPI backend
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.225.222:8000/chat'), // URL of your FastAPI backend
        headers: {'Content-Type': 'application/json'},
        body:
            json.encode({'message': message, "collactionName": collactionName}),
      );

      // Handle streaming response from the backend
      if (response.statusCode == 200) {
        print(response.body);
        // _handleStreamingResponse(response.body);
      } else {
        setState(() {
          widget.messages.add("Error: Unable to get response from API.");
        });
      }
    } catch (e) {
      setState(() {
        widget.messages.add("Error: Unable to connect to the server.");
      });
    }
  }

  // Handle the streaming response from FastAPI backend
  void _handleStreamingResponse(String responseBody) async {
    final streamResponse = utf8.decode(responseBody.codeUnits);
    setState(() {
      widget.messages.add("Bot: $streamResponse"); // Add bot's response
    });
    widget.onMessagesUpdated(
        widget.messages); // Notify parent widget about the updated messages
  }

  // Widget to display chat messages with correct alignment
  Widget _buildMessageWidget(String message, bool isUserMessage) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blueAccent : Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(225, 7, 7, 27),
      appBar: AppBar(
        title: Text("Chat on Page ${widget.pageIndex + 1}"),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                bool isUserMessage = widget.messages[index].startsWith("You:");
                return _buildMessageWidget(
                    widget.messages[index], isUserMessage);
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
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter your message...",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    _sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
