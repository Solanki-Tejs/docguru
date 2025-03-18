// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names

// import 'dart:convert';

import 'dart:convert';

import 'package:docguru/Animation/login-register.dart';
import 'package:docguru/PAGE/email_veri.dart';
import 'package:flutter/material.dart';
import 'package:docguru/PAGE/SignIn.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = dotenv.env['URL']! + "EmailCheck";

    var data = {
      "email": email.text,
    };
    var res = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));

    prefs.setString("userName", name.text);
    prefs.setString("email", email.text);

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
            padding: EdgeInsets.fromLTRB(scrwidth / 10, 0, scrwidth / 10, 0),
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
                        borderSide: BorderSide(color: Colors.white38),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white38),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white),
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
                        borderSide: BorderSide(color: Colors.white38),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white38),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white),
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
                        borderSide: BorderSide(color: Colors.white38),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white38),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white),
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
  }
}
