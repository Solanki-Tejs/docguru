import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  int selectedStars = 0;
  final TextEditingController feedbackController = TextEditingController();
  late AnimationController _controller;
  // late Animation<double> _scaleAnimation;
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // _scaleAnimation =
    //     CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    // _controller.forward();
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
      var star = "${_rating}";
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
    final Size size = MediaQuery.sizeOf(context);
    double scrwidth = size.width;
    //Screen hight
    double scrheight = size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // width: double.infinity,
            // height: double.infinity,
            padding: EdgeInsets.fromLTRB(
                scrwidth / 15, scrheight * 0.15, scrwidth / 15, 0),
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.feedback, size: 55, color: Colors.white),
                SizedBox(height: 22),
                Text(
                  "Feedback",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  "We value your feedback",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                RatingBar.builder(
                  // glow: true,
                  // glowRadius: 120,
                  unratedColor: Colors.white.withOpacity(0.2),
                  updateOnDrag: true,
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                SizedBox(height: 15),
                TextField(
                  controller: feedbackController,
                  maxLines: 8,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Write your comments here...",
                    hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 35),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
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
                          content:
                              Text("Feedback submitted with $_rating stars!")),
                    );
                    setState(() {
                      submint();
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
