// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names

import 'dart:convert';

import 'package:docguru/Animation/login-register.dart';
import 'package:docguru/PAGE/Home.dart';
// import 'package:docguru/PAGE/UploadFile.dart';
import 'package:docguru/PAGE/forgetpass.dart';
// import 'package:docguru/PAGE/rename_it.dart';
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

  final _formKey = GlobalKey<FormState>();

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
      print(res.statusCode);

      if (res.statusCode == 200) {
        print("hello world!");
        prefs.setString("token", Jres["token"]);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Detail dont match'),
          backgroundColor: Colors.red,
        ));
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
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.black),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(scrwidth / 10, 0, scrwidth / 10, 0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_open,
                      size: 70,
                      color: Colors.white,
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Enter your credentials to continue",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    // _buildTextField(Icons.email, "Email Address"),
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
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              createSlideRoute(Forgetpass(),
                                  position: 'right'));
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // _buildButton("Log In"),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey.shade300,
                        ),
                        child: Text(
                          "Log In",
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
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                createSlideRoute(SignUp(), position: 'right'));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
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
      ),
    );
  }
}
