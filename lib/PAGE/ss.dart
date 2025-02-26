import 'dart:ui';
import 'package:docguru/PAGE/Home.dart';
import 'package:docguru/PAGE/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:doc_wizard/pages/Login_page.dart';
// import 'package:doc_wizard/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _Splashscreen();
}

class _Splashscreen extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _initData();
  }

  Future<void> _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? isSignIn = prefs.getString('token');

    print(isSignIn);

    if (isSignIn != null) {
      // print('true');
      Future.delayed(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Home()));
        },
      );
    } else {
      // print('false');
      Future.delayed(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const SignIn()));
        },
      );
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // image: DecorationImage(
          //   // image: AssetImage('assets/images/background1.jpg'),
          //   fit: BoxFit.fill,
          // ),
          ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Scaffold(
            backgroundColor: const Color.fromARGB(121, 0, 0, 0),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      // decoration: const BoxDecoration(
                      //   image: DecorationImage(
                      //     image: AssetImage('assets/images/app_logo.png'),
                      //     fit: BoxFit.fill,
                      //   ),
                      // ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'DocWizard',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ]),
            )
            // ),
            ),
      ),
    );
  }
}
