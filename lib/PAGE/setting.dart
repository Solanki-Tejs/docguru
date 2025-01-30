// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names, camel_case_types

import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _Setting();
}

class _Setting extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(225, 7, 7, 27),
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
          // title: Text(
          //   "data",
          //   style: TextStyle(color: Colors.white),
          // ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.3),
          ),
          child: Column(children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      "Settings",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 11,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 23, 31),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: ListView(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Text(
                                "GENERAL",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            title: Text(
                              'Persnal info',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            // subtitle: Text('Name,e-mail,Number'),
                            onTap: () {
                              setState(() {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) => PersonInfo()));
                              });
                            },
                          ),
                          Divider(
                            height: 1,
                            thickness: 0,
                            indent: 20,
                            endIndent: 20,
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.chat_bubble,
                                  color: Colors.white, size: 25),
                            ),
                            title: Text(
                              'Manage Chat',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            onTap: () {},
                          ),
                          Divider(
                            height: 1,
                            thickness: 0,
                            indent: 20,
                            endIndent: 20,
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.contact_support_rounded,
                                  color: Colors.white, size: 25),
                            ),
                            title: Text(
                              'Contact Support',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            // subtitle: Text('Application detail,contac us'),
                            onTap: () {
                              // ContactSupportPage
                              setState(() {
                                //   Navigator.push(context,
                                //       MaterialPageRoute(builder: (context) => ContactSupportPage()));
                              });
                            },
                          ),
                          Divider(
                            height: 1,
                            thickness: 0,
                            indent: 20,
                            endIndent: 20,
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.info,
                                  color: Colors.white, size: 25),
                            ),
                            title: Text(
                              'About Us',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            // subtitle: Text('Application detail,contac us'),
                            onTap: () {
                              setState(
                                () {
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) => AppDetail()));
                                },
                              );
                            },
                          ),
                          // Divider(
                          //   height: 1,
                          //   thickness: 0,
                          //   indent: 20,
                          //   endIndent: 20,
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Text(
                                "FEEDBACK",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.feedback_outlined,
                                  color: Colors.white, size: 25),
                            ),
                            title: Text(
                              'Seend Feedback ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            // subtitle: Text('Application detail,contac us'),
                            onTap: () {
                              // ContactSupportPage
                              setState(() {
                                //   Navigator.push(context,
                                //       MaterialPageRoute(builder: (context) => ContactSupportPage()));
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ]),
        ));
  }
}
