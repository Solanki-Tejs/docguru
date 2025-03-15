import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  int selectedStars = 0;
  final TextEditingController feedbackController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  Future<void> submint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = dotenv.env['URL']! + "feedback";
    try {
      var msg = feedbackController.text;
      var star = "${selectedStars}";
      var token = prefs.getString("token");
      var data = {"token": token, "feedbackMSG": msg, "star": star};
      var res = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));

      var Jres = await jsonDecode(res.body);
      print(Jres);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffb048ff),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: const [
                    Text(
                      "We Appreciate Your Feedback!",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "We’re always looking for ways to enhance your experience. Please take a moment to share your thoughts with us.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 400,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedStars = index + 1;
                                });
                              },
                              child: Icon(
                                index < selectedStars
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 50,
                                color: index < selectedStars
                                    ? Colors.amber
                                    : const Color(0xff262ea1),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Expanded(
                          child: TextField(
                            controller: feedbackController,
                            maxLines: 6,
                            style: const TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              hintText: "Tell us how we can improve...",
                              hintStyle: const TextStyle(
                                  fontSize: 18, color: Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              contentPadding: const EdgeInsets.all(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffb048ff),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 40),
                          ),
                          onPressed: () {
                            if (feedbackController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please enter your feedback before submitting.")),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Feedback submitted with $selectedStars stars!")),
                            );
                            setState(() {
                              submint();
                              Navigator.of(context).pop();
                            });
                          },
                          child: const Text(
                            "Submit Feedback",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
