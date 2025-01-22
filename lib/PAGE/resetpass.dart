import 'package:docguru/Animation/login-register.dart';
import 'package:docguru/PAGE/newpass.dart';
import 'package:flutter/material.dart';

class Resetpass extends StatefulWidget {
  const Resetpass({super.key});

  @override
  State<Resetpass> createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpass> {
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
                        "Password Reset",
                        style: TextStyle(
                            color: Colors.white, fontSize: scrwidth / 10),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: scrheight / 10,
                  ),
                  TextFormField(
                      // controller: ,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.phonelink_lock_rounded),
                        labelText: 'verification code',
                      )),
                  SizedBox(
                    height: scrheight / 70,
                  ),
                  // Divider(
                  //   endIndent: scrwidth / 1.8,
                  //   indent: scrwidth / 40,
                  //   thickness: 2,
                  // ),
                  SizedBox(
                    height: scrheight / 70,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   "if you dont have account click ",
                      //   style: TextStyle(
                      //       color: Colors.white, fontSize: scrwidth / 27),
                      // ),
                      InkWell(
                        child: Text(
                          "Resend it",
                          style: TextStyle(
                              color: Colors.blue, fontSize: scrwidth / 27),
                        ),
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SignUp()));
                        },
                      )
                    ],
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
                            // login();
                            Navigator.push(context,
                              createSlideRoute(Newpass(), position: 'right'));
                          },
                          child: Text(
                            "Verifiy",
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
