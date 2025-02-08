// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names

// import 'dart:convert';

import 'package:docguru/Animation/login-register.dart';
import 'package:docguru/PAGE/email_veri.dart';
import 'package:flutter/material.dart';
import 'package:docguru/PAGE/SignIn.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    double scrwidth = size.width;
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
                  scrwidth / 20, scrheight * 0.20, scrwidth / 20, 0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'TimesNewRoman',
                                fontSize: scrwidth / 10),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: scrheight / 20,
                      ),
                      TextFormField(
                        controller: name,
                        style: TextStyle(
                          color: Colors.white,
                          //  fontFamily: 'Arial'
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.red,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'User Name',
                          // labelStyle: TextStyle(fontFamily: 'Arial'),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'UserName is required';
                          } else if (value.length >= 8) {
                            return 'Should atleast contain 8 character';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: scrheight / 70,
                      ),
                      TextFormField(
                        controller: email,
                        style: TextStyle(
                          color: Colors.white,
                          //  fontFamily: 'Arial'
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.red,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'E-mail',
                          // labelStyle: TextStyle(fontFamily: 'Arial'),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-mail is required';
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: scrheight / 70,
                      ),
                      TextFormField(
                        controller: password,
                        style: TextStyle(
                          color: Colors.white,
                          //  fontFamily: 'Arial'
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.red,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Password',
                          // labelStyle: TextStyle(fontFamily: 'Arial'),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          final passwordRegex = RegExp(
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
                          if (!passwordRegex.hasMatch(value)) {
                            return 'Password must be \n\t - atleast 8 characters long, \n\t - include one uppercase letter, \n\t - one lowercase letter, and one number';
                          }
                          return null;
                        },
                        obscureText: _obscureText,
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
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EmailVeri(
                                              email: email.text,
                                              name: name.text,
                                              password: password.text,
                                              RouteName: "SignUp")));
                                }
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Colors.white,
                                    // fontFamily: 'Arial',
                                    fontSize: scrwidth / 22),
                              ),
                              style: ButtonStyle(
                                  //color of button
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Color.alphaBlend(
                                              Colors.deepPurpleAccent,
                                              Colors.indigo)),
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
                            "if you have account click ",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Rokkitt',
                                fontSize: scrwidth / 27),
                          ),
                          InkWell(
                            child: Text(
                              "Here",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Rokkitt',
                                  fontSize: scrwidth / 27),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context, createSlideRoute(SignIn()));
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => SignIn()));
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
