// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names

import 'dart:convert';
import 'package:docguru/PAGE/rename_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmailVeri extends StatefulWidget {
  final String name, email, password;
  const EmailVeri({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  State<EmailVeri> createState() => _EmailVeriState();
}

class _EmailVeriState extends State<EmailVeri> {
  var send_otp;
  final otp = TextEditingController();
  @override
  void initState() {
    super.initState();
    email_veri();
  }

  Future<void> signup() async {
    print(send_otp);
    print(otp.text);
    if (send_otp == otp.text) {
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
      if (Jres["status"] == "200") {
        print("hello world!");
        prefs.setString("token", Jres["token"]);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RenameIt()));
      }
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
    if (Jres["status"] == "200") {
      send_otp = Jres["otp"];
    }
  }

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
                  scrwidth / 25, scrheight * 0.20, scrwidth / 25, 0),
              child: Form(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "E-mail verification",
                        style: TextStyle(
                            color: Colors.white, fontSize: scrwidth / 10),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: scrheight / 10,
                  ),
                  TextFormField(
                      controller: otp,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.phonelink_lock_rounded),
                        labelText: 'verification code',
                      )),
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
                              color: Colors.blue, fontSize: scrwidth / 27),
                        ),
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SignUp()));
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: scrheight / 30,
                  ),
                  SizedBox(
                      //height and width of button
                      //aane fix kari deje karvu hoi to
                      width: double.infinity,
                      height: scrheight * 0.059,
                      child: ElevatedButton(
                          onPressed: () {
                            // login();
                            signup();
                          },
                          child: Text(
                            "Verifiy",
                            style: TextStyle(
                                color: Colors.white, fontSize: scrwidth / 22),
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
