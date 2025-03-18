import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:docguru/Animation/login-register.dart';
import 'package:docguru/PAGE/SignIn.dart';
// import 'package:docguru/PAGE/rename_it.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Newpass extends StatefulWidget {
  final String email;
  final String pagename;
  Newpass({
    super.key,
    required this.email,
    required this.pagename,
  });

  @override
  State<Newpass> createState() => _NewpassState();
}

class _NewpassState extends State<Newpass> {
  bool _obscurePassText = true;
  bool _obscureConPassText = true;

  final configpassword = TextEditingController();
  final newpassword = TextEditingController();

  final _myForm = GlobalKey<FormState>();

  Future<void> SetNewPass() async {
    if (newpassword.text == configpassword.text) {
      print(widget.email);
      var data = {"email": widget.email, "password": configpassword.text};
      try {
        var url = dotenv.env['URL']! + "ResetPass";
        print(url);

        var res = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data));

        var Jres = await jsonDecode(res.body);
        print(Jres);
        if (res.statusCode == 200) {
          if (widget.pagename == "SignIn") {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          } else {
            Navigator.pop(context);
          }
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
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.black),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(scrwidth / 20, 0, scrwidth / 20, 0),
            child: Form(
              key: _myForm,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, size: 80, color: Colors.white),
                    SizedBox(height: 24),
                    Text(
                      "Set New Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Enter a new password for your account",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: newpassword,
                      obscureText: _obscurePassText,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.lock, color: Colors.grey, size: 28),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassText = !_obscurePassText;
                            });
                          },
                          child: Icon(_obscurePassText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        hintText: "New Password",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
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
                    TextFormField(
                      controller: configpassword,
                      obscureText: _obscureConPassText,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline,
                            color: Colors.grey, size: 28),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureConPassText = !_obscureConPassText;
                            });
                          },
                          child: Icon(_obscureConPassText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        print(value);
                        print(newpassword.text);
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value != newpassword.text) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (_myForm.currentState!.validate()) {
                          SetNewPass();
                        }
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
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
    //               key: _myForm,
    //               child: Column(
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Text(
    //                         "Set New Password",
    //                         style: TextStyle(
    //                             color: Colors.white,
    //                             fontFamily: 'TimesNewRoman',
    //                             fontSize: scrwidth / 15),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: scrheight / 15,
    //                   ),
    //                   TextFormField(
    //                     controller: newpassword,
    //                     style: TextStyle(color: Colors.white),
    //                     decoration: InputDecoration(
    //                       fillColor: Colors.red,
    //                       border: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(10)),
    //                       prefixIcon: const Icon(Icons.lock),
    //                       labelText: 'New Password',
    //                       suffixIcon: GestureDetector(
    //                         onTap: () {
    //                           setState(() {
    //                             _obscurePassText = !_obscurePassText;
    //                           });
    //                         },
    //                         child: Icon(_obscurePassText
    //                             ? Icons.visibility
    //                             : Icons.visibility_off),
    //                       ),
    //                     ),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return "Password is required";
    //                       }
    //                       final passwordRegex = RegExp(
    //                           r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    //                       if (!passwordRegex.hasMatch(value)) {
    //                         return 'Password must be \n\t - atleast 8 characters long, \n\t - no special symbols, \n\t - include one uppercase letter, \n\t - one lowercase letter, and one number';
    //                       }
    //                       return null;
    //                     },
    //                     obscureText: _obscurePassText,
    //                   ),
    //                   SizedBox(
    //                     height: scrheight / 70,
    //                   ),
    //                   TextFormField(
    //                     controller: configpassword,
    //                     style: TextStyle(color: Colors.white),
    //                     decoration: InputDecoration(
    //                       fillColor: Colors.red,
    //                       border: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(10)),
    //                       prefixIcon: const Icon(Icons.lock),
    //                       labelText: 'Confirm Password',
    //                       suffixIcon: GestureDetector(
    //                         onTap: () {
    //                           setState(() {
    //                             _obscureConPassText = !_obscureConPassText;
    //                           });
    //                         },
    //                         child: Icon(_obscureConPassText
    //                             ? Icons.visibility
    //                             : Icons.visibility_off),
    //                       ),
    //                     ),
    //                     validator: (value) {
    //                       print(value);
    //                       print(newpassword.text);
    //                       if (value == null || value.isEmpty) {
    //                         return "Password is required";
    //                       }
    //                       if (value != newpassword.text) {
    //                         return 'Password does not match';
    //                       }
    //                       return null;
    //                     },
    //                     obscureText: _obscureConPassText,
    //                   ),
    //                   SizedBox(
    //                     height: scrheight / 20,
    //                   ),
    //                   SizedBox(
    //                       //height and width of button
    //                       //aane fix kari deje karvu hoi to
    //                       width: double.infinity,
    //                       height: scrheight * 0.059,
    //                       child: ElevatedButton(
    //                           onPressed: () {
    //                             if (_myForm.currentState!.validate()) {
    //                               SetNewPass();
    //                             }
    //                             // login();
    //                           },
    //                           child: Text(
    //                             "Change password",
    //                             style: TextStyle(
    //                                 color: Colors.white,
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
    //                 ],
    //               )),
    //         ),
    //       )),
    // );
  }
}
