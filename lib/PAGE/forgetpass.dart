import 'package:docguru/Animation/login-register.dart';
import 'package:docguru/PAGE/email_veri.dart';
import 'package:flutter/material.dart';

class Forgetpass extends StatefulWidget {
  const Forgetpass({super.key});

  @override
  State<Forgetpass> createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass> {
  final email = TextEditingController();
  final _myForm = GlobalKey<FormState>();

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
    return Form(
      key: _myForm,
      child: Container(
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
                    scrwidth / 10, scrheight * 0.16, scrwidth / 10, 0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 100, color: Colors.white),
                    SizedBox(height: 30),
                    Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 32, // Increased font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Enter your email to reset your password.",
                        textAlign:
                            TextAlign.center, // Ensure text content is centered
                        style: TextStyle(color: Colors.white70, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20), // Increased font size
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black87,
                        prefixIcon: Icon(Icons.email, color: Colors.white60),
                        hintText: "Email Address",
                        hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 20), // Increased font size
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
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        if (_myForm.currentState!.validate()) {
                          Navigator.push(
                              context,
                              createSlideRoute(
                                  EmailVeri(
                                    email: email.text,
                                    RouteName: "ForgotPass",
                                  ),
                                  position: 'right'));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white70, // Off white submit button
                        minimumSize: Size(
                            double.infinity, 70), // Increased button height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadowColor: Colors.white60,
                        elevation: 15,
                      ),
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black), // Increased font size
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
