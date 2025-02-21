// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names, camel_case_types

import 'dart:ui';

import 'package:docguru/PAGE/ChatPage.dart';
import 'package:docguru/PAGE/SignIn.dart';
import 'package:docguru/PAGE/setting.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> logout() async {
    print("object");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    print(token);
    await pref.remove('token');

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
        (Route) => false);
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
    return Scaffold(
        // backgroundColor: Colors.transparent,
        backgroundColor: Color.fromARGB(225, 7, 7, 27),
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          title: Text(
            "DocGuru",
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: Drawer(
          width: scrwidth / 1.2,
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: const Color.fromARGB(255, 64, 63, 63).withOpacity(0.3),
                child: Column(
                  children: [
                    SizedBox(
                      height: scrheight / 8,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "DocGuru",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ListTile(
                            // hoverColor: Colors.deepPurpleAccent,
                            splashColor: Colors.deepPurpleAccent,
                            // selectedColor: Colors.deepPurpleAccent,
                            // tileColor: Colors.deepPurpleAccent,
                            // focusColor: Colors.deepPurpleAccent,
                            // selectedTileColor: Colors.deepPurpleAccent,
                            leading: Icon(Icons.description_outlined,
                                color: Colors.white),
                            title: Text("PDF name",
                                style: TextStyle(color: Colors.white)),
                            onTap: () {},
                          ),
                          // Add more menu items as needed.
                        ],
                      ),
                    ),
                    Divider(color: Colors.white70, thickness: 0.5),
                    Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.settings, color: Colors.white),
                          title: Text(
                            'Settings',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Setting()));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.logout, color: Colors.white),
                          title: Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            logout();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: ChatPage());
  }
}
