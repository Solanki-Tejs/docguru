import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RenameIt extends StatefulWidget {
  const RenameIt({super.key});

  @override
  State<RenameIt> createState() => _RenameItState();
}

class _RenameItState extends State<RenameIt> {
  Future<void> hello() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("token"));
  }

  @override
  Widget build(BuildContext context) {
    hello();
    return Text("hello world!");
  }
}
