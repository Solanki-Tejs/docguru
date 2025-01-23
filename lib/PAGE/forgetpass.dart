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
                        "Forget Passwor",
                        style: TextStyle(
                            color: Colors.white, fontSize: scrwidth / 10),
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
                      )),
                  SizedBox(
                    height: scrheight / 70,
                  ),
                  SizedBox(
                    height: scrheight / 70,
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
                            Navigator.push(
                                context,
                                createSlideRoute(
                                    EmailVeri(
                                      email: email.text,RouteName: "ForgotPass",
                                    ),
                                    position: 'right'));
                          },
                          child: Text(
                            "Send OTP",
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
