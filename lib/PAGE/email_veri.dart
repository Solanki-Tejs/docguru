// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names

import 'dart:async';
import 'dart:convert';
import 'package:docguru/PAGE/Home.dart';
import 'package:docguru/PAGE/newpass.dart';
import 'package:docguru/PAGE/rename_it.dart';
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
  // var send_otp = '102003';
  var send_otp;
  final otp = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Send OTP
    email_veri();
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
          fontSize: 20,
          color: Color.fromARGB(225, 7, 7, 27),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Color.fromRGBO(142, 147, 159, 1),
        // border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: Color.fromRGBO(160, 142, 211, 1),

      // border: Border.all(color: Color.fromRGBO(160, 142, 211, 1)),
      borderRadius: BorderRadius.circular(15),
    );

    return Container(
      //backgroundColor change
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(color: Color.fromARGB(225, 7, 7, 27)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              //padding for text and textfild
              padding: EdgeInsets.fromLTRB(
                  scrwidth / 20, scrheight * 0.20, scrwidth / 20, 0),
              child: Form(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "E-mail verification",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'TimesNewRoman',
                            fontSize: scrwidth / 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: scrheight / 15,
                  ),
                  Center(
                    child: Text(
                      'An OTP has been send at',
                      style: TextStyle(
                          color: Colors.white,
                          // fontFamily: 'Arial',
                          fontSize: scrwidth / 23),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.email,
                      style: TextStyle(
                          color: Colors.white,
                          // fontFamily: 'Arial',
                          fontWeight: FontWeight.w800,
                          fontSize: scrwidth / 27),
                    ),
                  ),
                  SizedBox(
                    height: scrheight / 20,
                  ),
                  Pinput(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    length: 6,
                    // onCompleted: (pin) {
                    //   print(widget.RouteName);
                    //   if (widget.RouteName == "ForgotPass") {
                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => Newpass(
                    //                   email: widget.email,
                    //                 )));
                    //   } else {
                    //     signup(pin);
                    //   }
                    // },
                  ),
                  // TextFormField(
                  //     controller: otp,
                  //     style: TextStyle(color: Colors.white),
                  //     decoration: InputDecoration(
                  //       fillColor: Colors.red,
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //       prefixIcon: const Icon(Icons.phonelink_lock_rounded),
                  //       labelText: 'verification code',
                  //     )),
                  SizedBox(
                    height: scrheight / 70,
                  ),
                  // Divider(
                  //   endIndent: scrwidth / 1.8,
                  //   indent: scrwidth / 40,
                  //   thickness: 2,
                  // ),
                  SizedBox(
                    height: scrheight / 70,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   "if you dont have account click ",
                      //   style: TextStyle(
                      //       color: Colors.white, fontSize: scrwidth / 27),
                      // ),
                      InkWell(
                          child: Text(
                            "Resend it",
                            style: TextStyle(
                                color: Colors.blue,
                                // fontFamily: 'Arial',
                                fontSize: scrwidth / 27),
                          ),
                          onTap: () {
                            print('resent otp');
                          })
                    ],
                  ),
                  SizedBox(
                    height: scrheight / 15,
                  ),
                  SizedBox(
                      //height and width of button
                      //aane fix kari deje karvu hoi to
                      width: double.infinity,
                      height: scrheight * 0.059,
                      child: ElevatedButton(
                          onPressed: () {
                            // login();
                            print(widget.RouteName);
                            if (widget.RouteName == "ForgotPass") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Newpass(
                                            email: widget.email,
                                          )));
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
                          child: Text(
                            "Verifiy",
                            style: TextStyle(
                                color: Colors.white,
                                // fontFamily: 'Arial',
                                fontSize: scrwidth / 22),
                          ),
                          style: ButtonStyle(
                              //color of button
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Color.alphaBlend(
                                      Colors.deepPurpleAccent, Colors.indigo)),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                //side: BorderSide(color: Colors.red)
                              ))))),
                ],
              )),
            ),
          )),
    );
  }
}
