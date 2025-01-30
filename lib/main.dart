// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names, camel_case_types

import 'package:docguru/PAGE/Home.dart';
import 'package:docguru/PAGE/SignIn.dart';
import 'package:docguru/PAGE/email_veri.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SafeArea(
      top: true,
      child: SignIn(),
    ),
  ));
}

class Main_page extends StatefulWidget {
  const Main_page({super.key});

  @override
  State<Main_page> createState() => _Main_pageState();
}

class _Main_pageState extends State<Main_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(225, 7, 7, 27),
      body: Center(
        child: Text(
          "hello world!",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
