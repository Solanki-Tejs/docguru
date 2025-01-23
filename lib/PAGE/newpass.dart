import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:docguru/Animation/login-register.dart';
import 'package:docguru/PAGE/SignIn.dart';
import 'package:docguru/PAGE/rename_it.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Newpass extends StatefulWidget {
  final String email;
  Newpass({super.key, required this.email});

  @override
  State<Newpass> createState() => _NewpassState();
}

class _NewpassState extends State<Newpass> {
  bool _obscureText = true;

  final configpassword = TextEditingController();
  final newpassword = TextEditingController();

  Future<void> SetNewPass() async {
    if (newpassword.text == configpassword.text) {
      print(widget.email);
      var data = {
        "email": widget.email,
        "password": configpassword.text
      };
      try {
        var url = dotenv.env['URL']! + "ResetPass";
        print(url);

        var res = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data));

        var Jres = await jsonDecode(res.body);
        print(Jres);
        if (Jres["status"] == "200") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignIn()));
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("dont match");
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
                        "Set New Password",
                        style: TextStyle(
                            color: Colors.white, fontSize: scrwidth / 10),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: scrheight / 30,
                  ),
                  TextFormField(
                    controller: newpassword,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: Colors.red,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Password',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    obscureText: _obscureText,
                  ),
                  SizedBox(
                    height: scrheight / 70,
                  ),
                  TextFormField(
                    controller: configpassword,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: Colors.red,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Password',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    obscureText: _obscureText,
                  ),
                  SizedBox(
                    height: scrheight / 20,
                  ),
                  SizedBox(
                      //height and width of button
                      //aane fix kari deje karvu hoi to
                      width: double.infinity,
                      height: scrheight * 0.059,
                      child: ElevatedButton(
                          onPressed: () {
                            // login();
                            SetNewPass();
                          },
                          child: Text(
                            "Config",
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
                  SizedBox(
                    height: scrheight / 10,
                  ),
                ],
              )),
            ),
          )),
    );
  }
}
