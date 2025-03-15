import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatPage extends StatefulWidget {
  final int pageIndex;
  final List<String> messages; // Holds chat messages for this specific page
  final Function(List<String>) onMessagesUpdated;
  final dynamic pageName; // Callback to update parent state

  const ChatPage({
    super.key,
    required this.pageName,
    required this.pageIndex,
    required this.messages,
    required this.onMessagesUpdated,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isSend = false;
  StreamSubscription? _responseSubscription; // Declare stream subscription

  Future<void> onPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("onPage", widget.pageIndex);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _stopMessage() async {
    print('Stopping the message');

    var url = dotenv.env['URL']! + "endChat";
    await http
        .get(Uri.parse(url)); // Stop message from server side if necessary

    setState(() {
      isSend = false;
      int botIndex = widget.messages.length - 1;
      if (widget.messages[botIndex] == "loading...") {
        widget.messages[botIndex] = "Bot: Ended";
      }
    });

    // Cancel the ongoing response stream
    if (_responseSubscription != null) {
      await _responseSubscription?.cancel();
      print("Stream has been canceled");
    }

    widget.onMessagesUpdated(widget.messages);
  }

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    final startTime = DateTime.now();

    setState(() {
      isSend = true;
      widget.messages.add("You: $message");
    });
    _scrollToBottom();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var collactionName =
        prefs.getString('CollactionNames_${widget.pageIndex}_name');
    print("Collection Name: $collactionName");

    String? token = prefs.getString('token');
    var url = dotenv.env['URL']! + "chat";
    try {
      final request = http.Request("POST", Uri.parse(url));
      request.headers["Content-Type"] = "application/json";
      request.body = jsonEncode({
        "message": message,
        "collactionName": collactionName,
        "token": token
      });

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        String botReply = "";

        // Add a placeholder message for the bot (loading state)
        setState(() {
          widget.messages.add("loading...");
        });
        _scrollToBottom();

        int botIndex = widget.messages.length - 1;

        // Store the stream subscription
        _responseSubscription =
            response.stream.transform(utf8.decoder).listen((chunk) {
          final endTime = DateTime.now();
          final responseTime = endTime.difference(startTime).inMilliseconds;
          print("Response Time: ${responseTime}ms");
          print("Received chunk: $chunk");

          botReply += chunk;

          // Update bot's message in the UI
          setState(() {
            widget.messages[botIndex] = "Bot: $botReply";
          });
          _scrollToBottom();
        }, onDone: () {
          setState(() {
            isSend = false;
          });
          print("Stream finished");
          widget.onMessagesUpdated(widget.messages);
        }, onError: (error) {
          setState(() {
            isSend = false;
            widget.messages[botIndex] =
                "Error: Unable to process the response.";
          });
          print("Stream error: $error");
          _scrollToBottom();
        });
      } else {
        setState(() {
          isSend = false;
          widget.messages.add("Error: Unable to get response from API.");
        });
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        isSend = false;
        widget.messages.add("Error: Unable to connect to the server.");
      });
      _scrollToBottom();
    }
  }

  Widget _buildMessageWidget(String message, bool isUserMessage) {
    final boldRegex = RegExp(r'\*\*(.*?)\*\*');
    List<TextSpan> textSpans = [];

    int start = 0;

    // Iterate through the message and split it at the ** markers
    boldRegex.allMatches(message).forEach((match) {
      // Add text before the **bold** section
      if (match.start > start) {
        textSpans.add(TextSpan(
          text: message.substring(start, match.start),
          style: TextStyle(
            // color: isUserMessage ? Colors.white : Colors.black,
            color: Colors.white,
          ),
        ));
      }

      // Add the bold part
      textSpans.add(TextSpan(
        text: match.group(1), // The text inside **
        style: TextStyle(
          fontWeight: FontWeight.bold,
          // color: isUserMessage ? Colors.white : Colors.black,
          color: Colors.white,
        ),
      ));

      start = match.end; // Update start position for the next segment
    });

    // Add any remaining text after the last **bold** part
    if (start < message.length) {
      textSpans.add(TextSpan(
        text: message.substring(start),
        style: TextStyle(
          // color: isUserMessage ? Colors.black : Colors.white,
          color: Colors.white,
        ),
      ));
    }

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: isUserMessage
            ? EdgeInsets.only(bottom: 2, left: 50, right: 2, top: 2)
            : EdgeInsets.only(bottom: 2, left: 2, right: 50, top: 2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                color: isUserMessage
                    ? Colors.white.withOpacity(0.2) // Frosted effect
                    : Colors.transparent, // Fully transparent
                borderRadius: BorderRadius.circular(12),
              ),
              child: message == "loading..."
                  ? SizedBox(
                      width: 25,
                      child: SpinKitThreeBounce(
                          // color: isUserMessage ? Colors.white : Colors.black,
                          color: Colors.white,
                          size: 15),
                    )
                  : RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        // color: isUserMessage ? Colors.white : Colors.black),
                        children: textSpans,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    onPage();
    _scrollToBottom();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
                    minLines: 1,
                    maxLines: 8,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter your message...",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ),
                isSend
                    ? SizedBox(
                        width: 60,
                        child: IconButton(
                          icon: Icon(
                            Icons.stop_circle,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {
                            _stopMessage();
                            _controller.clear();
                          },
                        ),
                      )
                    : SizedBox(
                        width: 60,
                        child: IconButton(
                          icon: Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            _sendMessage(_controller.text);
                            _controller.clear();
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
