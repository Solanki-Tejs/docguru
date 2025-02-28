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

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    final startTime = DateTime.now();

    setState(() {
      widget.messages.add("You: $message");
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var collactionName =
        prefs.getString('CollactionNames_${widget.pageIndex}_name');
    print("Collection Name: $collactionName");

    try {
      final request =
          http.Request("POST", Uri.parse('http://192.168.225.83:8000/chat'));
      request.headers["Content-Type"] = "application/json";
      request.body =
          jsonEncode({"message": message, "collactionName": collactionName});

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        String botReply = "";

        // Add a placeholder message for the bot
        setState(() {
          widget.messages.add("Bot: ..."); // Shows "typing..." indicator
        });

        int botIndex = widget.messages.length - 1; // Save bot's message index

        response.stream.transform(utf8.decoder).listen((chunk) {
          final endTime = DateTime.now();
          final responseTime = endTime.difference(startTime).inMilliseconds;
          print("Response Time: ${responseTime}ms");
          print("Received chunk: $chunk");

          botReply += chunk; // Append new chunks

          // Update the specific message in the list
          setState(() {
            widget.messages[botIndex] =
                "Bot: $botReply"; // Update bot's message in UI
          });
        }, onDone: () {
          print("Stream finished");
          widget.onMessagesUpdated(widget.messages);
        }, onError: (error) {
          print("Stream error: $error");
          setState(() {
            widget.messages[botIndex] =
                "Error: Unable to process the response.";
          });
        });
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
    final streamResponse =
        utf8.decode(responseBody.codeUnits, allowMalformed: true);
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
