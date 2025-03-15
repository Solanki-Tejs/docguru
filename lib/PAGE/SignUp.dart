// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names

// import 'dart:convert';

import 'dart:convert';

import 'package:docguru/Animation/login-register.dart';
import 'package:docguru/PAGE/email_veri.dart';
import 'package:flutter/material.dart';
import 'package:docguru/PAGE/SignIn.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

  Future<void> EmailCheck() async {
    var url = dotenv.env['URL']! + "EmailCheck";

    var data = {
      "email": email.text,
    };
    var res = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));

    print(res.statusCode);
    if (res.statusCode != 403) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmailVeri(
                  email: email.text,
                  name: name.text,
                  password: password.text,
                  RouteName: "SignUp")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email exits'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    double scrwidth = size.width;
    double scrheight = size.height;
    print(scrheight);
    print(scrwidth);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                scrwidth / 10, scrheight * 0.10, scrwidth / 10, 0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 70,
                    color: Colors.white,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Create an account to get started",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  // _buildTextField(Icons.person, "Full Name"),
                  TextFormField(
                    controller: name,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.person, color: Colors.white70, size: 26),
                      hintText: "User Name",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'UserName is required';
                      } else if (value.length < 8) {
                        return 'Should atleast contain 8 character';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: email,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.email, color: Colors.white70, size: 26),
                      hintText: "Email Address",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
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
                  SizedBox(height: 25),
                  TextFormField(
                    controller: password,
                    obscureText: _obscureText,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.lock, color: Colors.white70, size: 26),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                          size: 26,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      final passwordRegex = RegExp(
                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
                      if (!passwordRegex.hasMatch(value)) {
                        return 'Password must be \n\t - atleast 8 characters long, \n\t - no special symbols, \n\t - include one uppercase letter, \n\t - one lowercase letter, and one number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),

                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        EmailCheck();
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade300,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade700,
                            blurRadius: 15,
                            spreadRadius: 4,
                            offset: Offset(6, 6),
                          ),
                          BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 15,
                            spreadRadius: 4,
                            offset: Offset(-6, -6),
                          ),
                        ],
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, createSlideRoute(SignIn()));
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // return Container(
    //   //backgroundColor change
    //   height: double.infinity,
    //   width: double.infinity,
    //   decoration: const BoxDecoration(color: Color.fromARGB(225, 7, 7, 27)),
    //   child: Scaffold(
    //       backgroundColor: Colors.transparent,
    //       body: SingleChildScrollView(
    //         child: Padding(
    //           //padding for text and textfild
    //           padding: EdgeInsets.fromLTRB(
    //               scrwidth / 20, scrheight * 0.20, scrwidth / 20, 0),
    //           child: Form(
    //               key: _formKey,
    //               child: Column(
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Text(
    //                         "Sign up",
    //                         style: TextStyle(
    //                             color: Colors.white,
    //                             fontFamily: 'TimesNewRoman',
    //                             fontSize: scrwidth / 10),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: scrheight / 20,
    //                   ),
    //                   TextFormField(
    //                     controller: name,
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       //  fontFamily: 'Arial'
    //                     ),
    //                     decoration: InputDecoration(
    //                       fillColor: Colors.red,
    //                       border: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(10)),
    //                       prefixIcon: const Icon(Icons.person),
    //                       labelText: 'User Name',
    //                       // labelStyle: TextStyle(fontFamily: 'Arial'),
    //                     ),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return 'UserName is required';
    //                       } else if (value.length >= 8) {
    //                         return 'Should atleast contain 8 character';
    //                       }
    //                       return null;
    //                     },
    //                   ),
    //                   SizedBox(
    //                     height: scrheight / 70,
    //                   ),
    //                   TextFormField(
    //                     controller: email,
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       //  fontFamily: 'Arial'
    //                     ),
    //                     decoration: InputDecoration(
    //                       fillColor: Colors.red,
    //                       border: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(10)),
    //                       prefixIcon: const Icon(Icons.email),
    //                       labelText: 'E-mail',
    //                       // labelStyle: TextStyle(fontFamily: 'Arial'),
    //                     ),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return 'E-mail is required';
    //                       }
    //                       final emailRegex =
    //                           RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    //                       if (!emailRegex.hasMatch(value)) {
    //                         return 'Enter a valid email address';
    //                       }
    //                       return null;
    //                     },
    //                   ),
    //                   SizedBox(
    //                     height: scrheight / 70,
    //                   ),
    //                   TextFormField(
    //                     controller: password,
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       //  fontFamily: 'Arial'
    //                     ),
    //                     decoration: InputDecoration(
    //                       fillColor: Colors.red,
    //                       border: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(10)),
    //                       prefixIcon: const Icon(Icons.lock),
    //                       labelText: 'Password',
    //                       // labelStyle: TextStyle(fontFamily: 'Arial'),
    //                       suffixIcon: GestureDetector(
    //                         onTap: () {
    //                           setState(() {
    //                             _obscureText = !_obscureText;
    //                           });
    //                         },
    //                         child: Icon(_obscureText
    //                             ? Icons.visibility
    //                             : Icons.visibility_off),
    //                       ),
    //                     ),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return 'Password is required';
    //                       }
    //                       final passwordRegex = RegExp(
    //                           r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    //                       if (!passwordRegex.hasMatch(value)) {
    //                         return 'Password must be \n\t - atleast 8 characters long, \n\t - no special symbols, \n\t - include one uppercase letter, \n\t - one lowercase letter, and one number';
    //                       }
    //                       return null;
    //                     },
    //                     obscureText: _obscureText,
    //                   ),
    //                   SizedBox(
    //                     height: scrheight / 15,
    //                   ),
    //                   SizedBox(
    //                       //height and width of button
    //                       //aane fix kari deje karvu hoi to
    //                       width: double.infinity,
    //                       height: scrheight * 0.059,
    //                       child: ElevatedButton(
    //                           onPressed: () {
    //                             if (_formKey.currentState!.validate()) {
    //                               EmailCheck();
    //                             }
    //                           },
    //                           child: Text(
    //                             "Sign up",
    //                             style: TextStyle(
    //                                 color: Colors.white,
    //                                 // fontFamily: 'Arial',
    //                                 fontSize: scrwidth / 22),
    //                           ),
    //                           style: ButtonStyle(
    //                               //color of button
    //                               backgroundColor:
    //                                   WidgetStateProperty.all<Color>(
    //                                       Color.alphaBlend(
    //                                           Colors.deepPurpleAccent,
    //                                           Colors.indigo)),
    //                               shape: WidgetStateProperty.all<
    //                                       RoundedRectangleBorder>(
    //                                   RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.circular(10.0),
    //                                 //side: BorderSide(color: Colors.red)
    //                               ))))),
    //                   SizedBox(
    //                     height: scrheight / 10,
    //                   ),
    //                   Divider(
    //                     endIndent: scrwidth / 3,
    //                     indent: scrwidth / 3,
    //                     thickness: 2,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Text(
    //                         "if you have account click ",
    //                         style: TextStyle(
    //                             color: Colors.white,
    //                             fontFamily: 'Rokkitt',
    //                             fontSize: scrwidth / 27),
    //                       ),
    //                       InkWell(
    //                         child: Text(
    //                           "Here",
    //                           style: TextStyle(
    //                               color: Colors.blue,
    //                               fontFamily: 'Rokkitt',
    //                               fontSize: scrwidth / 27),
    //                         ),
    //                         onTap: () {
    //                           Navigator.push(
    //                               context, createSlideRoute(SignIn()));
    //                           //   Navigator.push(
    //                           //       context,
    //                           //       MaterialPageRoute(
    //                           //           builder: (context) => SignIn()));
    //                         },
    //                       )
    //                     ],
    //                   ),
    //                 ],
    //               )),
    //         ),
    //       )),
    // );
  }
}
