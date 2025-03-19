// import 'dart:ui';
// import 'package:docguru/PAGE/Home.dart';
// import 'package:docguru/PAGE/SignIn.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});

//   @override
//   State<Splashscreen> createState() => _Splashscreen();
// }

// class _Splashscreen extends State<Splashscreen>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//     _initData();
//   }

//   Future<void> _initData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? isSignIn = prefs.getString('token');

//     print(isSignIn);

//     if (isSignIn != null) {
//       Future.delayed(
//         const Duration(seconds: 3),
//         () {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => const Home()));
//         },
//       );
//     } else {
//       // print('false');
//       Future.delayed(
//         const Duration(seconds: 3),
//         () {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => SignIn()));
//         },
//       );
//     }
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           // image: DecorationImage(
//           //   // image: AssetImage('assets/images/background1.jpg'),
//           //   fit: BoxFit.fill,
//           // ),
//           ),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//         child: Scaffold(
//             backgroundColor: const Color.fromARGB(121, 0, 0, 0),
//             body: Center(
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 120,
//                       height: 120,
//                       // decoration: const BoxDecoration(
//                       //   image: DecorationImage(
//                       //     image: AssetImage('assets/images/app_logo.png'),
//                       //     fit: BoxFit.fill,
//                       //   ),
//                       // ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     const Text(
//                       'DocGuru',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 30),
//                     ),
//                   ]),
//             )
//             // ),
//             ),
//       ),
//     );
//   }
// }

// import 'dart:ui';
// import 'package:docguru/PAGE/Home.dart';
// import 'package:docguru/PAGE/SignIn.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});

//   @override
//   State<Splashscreen> createState() => _Splashscreen();
// }

// class _Splashscreen extends State<Splashscreen> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

//     _controller = VideoPlayerController.asset("assets/splash.mp4")
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//         _controller.setLooping(false);
//       });

//     _initData();
//   }

//   Future<void> _initData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? isSignIn = prefs.getString('token');

//     Future.delayed(
//       Duration(seconds: 5), // Adjust duration to match video length
//       () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (_) => isSignIn != null ? const Home() : SignIn()),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:docguru/PAGE/Home.dart';
import 'package:docguru/PAGE/SignIn.dart';
import 'package:docguru/PAGE/newpass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _Splashscreen();
}

class _Splashscreen extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  double _size = 50; // Initial small size
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _size = 150; // Expanding to final size
      });
    });

    _initData();
  }

  Future<void> getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = dotenv.env['URL']! + "getdata";
      print(url);
      var token = prefs.getString('token');
      print(token);
      var data = {"token": token};
      var res = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));

      var Jres = await jsonDecode(res.body);
      print(res.statusCode);

      if (res.statusCode == 200) {
        prefs.setString("userName", Jres["name"]);
        prefs.setString("email", Jres["email"]);
        prefs.setString("pass", Jres["pass"]);
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future<void> _initData() async {
    prefs = await SharedPreferences.getInstance();
    String? isSignIn = prefs.getString('token');

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (isSignIn != null) {
          getdata();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Home()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => SignIn()),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LiquidCircularProgressIndicator(
            //   value: 1.0, // Fills up completely
            //   backgroundColor: Colors.black,
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            //   center: Image.asset("assets/splash_logo.png", width: 100),
            // ),
            AnimatedContainer(
              duration: const Duration(seconds: 3),
              curve: Curves.easeOutExpo,
              width: _size * 2,
              height: _size * 2,
              child: Image.asset("assets/splash_logo.png"),
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              opacity: _size == 150 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1500),
              child: Text(
                'DocGuru',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
