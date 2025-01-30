// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names

import 'dart:convert';

import 'package:docguru/Animation/login-register.dart';
import 'package:docguru/PAGE/Home.dart';
import 'package:docguru/PAGE/forgetpass.dart';
import 'package:docguru/PAGE/rename_it.dart';
import 'package:flutter/material.dart';
import 'package:docguru/PAGE/SignUp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obscureText = true;

  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> login() async {
    print(email.text);
    print(password.text);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {"email": email.text, "password": password.text};
    try {
      var url = dotenv.env['URL']! + "SignIn";
      print(url);

      var res = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));

      var Jres = await jsonDecode(res.body);
      print(Jres['status']);

      if (Jres["status"] == "200") {
        print("hello world!");
        prefs.setString("token", Jres["token"]);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } catch (e) {
      print(e);
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
                        "Login",
                        style: TextStyle(
                            color: Colors.white, fontSize: scrwidth / 10),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: scrheight / 30,
                  ),
                  // TextFormField(
                  //     decoration: InputDecoration(
                  //   fillColor: Colors.red,
                  //   border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10)),
                  //   prefixIcon: const Icon(Icons.person),
                  //   labelText: 'User Name',
                  // )),
                  // SizedBox(
                  //   height: scrheight / 70,
                  // ),
                  TextFormField(
                      controller: email,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'E-mail',
                      )),
                  SizedBox(
                    height: scrheight / 70,
                  ),
                  TextFormField(
                    controller: password,
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
                  Row(children: [
                    InkWell(
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            createSlideRoute(Forgetpass(), position: 'right'));
                      },
                    ),
                  ]),
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
                            login();
                          },
                          child: Text(
                            "Login",
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
                  Divider(
                    endIndent: scrwidth / 3,
                    indent: scrwidth / 3,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "if you dont have account click ",
                        style: TextStyle(
                            color: Colors.white, fontSize: scrwidth / 27),
                      ),
                      InkWell(
                        child: Text(
                          "Here",
                          style: TextStyle(
                              color: Colors.blue, fontSize: scrwidth / 27),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              createSlideRoute(SignUp(), position: 'right'));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SignUp()));
                        },
                      )
                    ],
                  ),
                ],
              )),
            ),
          )),
    );
  }
}
