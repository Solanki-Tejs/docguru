import 'dart:async';
import 'dart:convert';
import 'package:docguru/PAGE/Home.dart';
import 'package:docguru/PAGE/newpass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailVeri extends StatefulWidget {
  final String email, RouteName;
  String? name, password;
  EmailVeri({
    super.key,
    this.name,
    this.password,
    required this.email,
    required this.RouteName,
  });

  @override
  State<EmailVeri> createState() => _EmailVeriState();
}

class _EmailVeriState extends State<EmailVeri> {
  bool isResendDisabled = false;
  int resendCooldown = 60;
  int baseCooldown = 60;
  var send_otp;
  final otp = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Send OTP
    email_veri();
  }

  void startResendTimer() {
    setState(() => isResendDisabled = true);
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendCooldown == 0) {
        timer.cancel();
        setState(() {
          isResendDisabled = false;
          baseCooldown *= 2; // Double the cooldown for the next click
          resendCooldown = baseCooldown; // Reset to new doubled cooldown
        });
      } else {
        setState(() => resendCooldown--);
      }
    });
  }

  Future<void> signup(otp) async {
    // print(send_otp);
    print(otp);
    // print(se);
    if (send_otp == otp) {
      print('Verification successfull');
      print(widget.email);

      print(widget.name);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var data = {
        "name": widget.name,
        "email": widget.email,
        "password": widget.password
      };
      var url = dotenv.env['URL']! + "SignUp";
      print(url);
      var res = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));

      var Jres = jsonDecode(res.body);
      if (res.statusCode == 200) {
        print("hello world!");
        prefs.setString("token", Jres["token"]);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid PIN! Try again.")),
      );
      _pinController.clear();
    }
  }

  Future<void> email_veri() async {
    var data = {
      "email": widget.email,
    };
    var url = dotenv.env['URL']! + "EmailVeri";
    print(url);
    var res = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
    print(res.body);
    var Jres = await jsonDecode(res.body);
    if (res.statusCode == 200) {
      send_otp = Jres["otp"];
    }
  }

  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //screen size
    final Size size = MediaQuery.sizeOf(context);
    //Screen width
    double scrwidth = size.width;
    //Screen hight
    double scrheight = size.height;
    print(scrheight);
    print(scrwidth);
    print(widget.email);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        // color: Color.fromRGBO(142, 147, 159, 1),
        color: Colors.transparent,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: Colors.white60,

      // border: Border.all(color: Color.fromRGBO(160, 142, 211, 1)),
      borderRadius: BorderRadius.circular(15),
    );

    return Container(
      //backgroundColor change
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.black),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              //padding for text and textfild
              padding: EdgeInsets.fromLTRB(
                  scrwidth / 20, scrheight * 0.20, scrwidth / 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_user, size: 75, color: Colors.white),
                  SizedBox(height: 25),
                  Text(
                    "Enter Verification Code",
                    style: TextStyle(
                      fontSize: 26, // Increased font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "We've sent a code to ${widget.email}",
                      textAlign: TextAlign.center, // Ensure text is centered
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 30),
                  Pinput(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    length: 6,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      print(widget.RouteName);
                      if (widget.RouteName == "ForgotPass") {
                        String otp = _pinController.text;
                        print("In verify:" + otp);
                        if (otp.isEmpty || otp.length < 6) {
                          return;
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Newpass(
                                        email: widget.email,
                                      )));
                        }
                      } else {
                        String otp = _pinController.text;
                        print("In verify:" + otp);
                        if (otp.isEmpty || otp.length < 6) {
                          return;
                        } else {
                          signup(otp);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white70, // Off white submit button
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: Colors.white60,
                      elevation: 12,
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 25),
                  TextButton(
                    onPressed: isResendDisabled
                        ? null
                        : () {
                            email_veri();
                            print('resent otp');
                            startResendTimer();
                          },
                    child: Text(
                      isResendDisabled
                          ? "Resend Code (${resendCooldown}s)"
                          : "Resend Code",
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
