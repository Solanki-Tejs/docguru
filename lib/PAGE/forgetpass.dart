import 'package:docguru/Animation/login-register.dart';
import 'package:docguru/PAGE/email_veri.dart';
import 'package:docguru/PAGE/newpass.dart';
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
                  key: _myForm,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Forget Password",
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
                      TextFormField(
                        controller: email,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          fillColor: Colors.red,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'E-mail',
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
                      SizedBox(
                        height: scrheight / 70,
                      ),
                      SizedBox(
                        height: scrheight / 25,
                      ),
                      SizedBox(
                          //height and width of button
                          //aane fix kari deje karvu hoi to
                          width: double.infinity,
                          height: scrheight * 0.059,
                          child: ElevatedButton(
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
                              child: Text(
                                "Send OTP",
                                style: TextStyle(
                                    color: Colors.white,
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
                    ],
                  )),
            ),
          )),
    );
  }
}
