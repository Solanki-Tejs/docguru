// // ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names, camel_case_types

// import 'package:flutter/material.dart';

// class Setting extends StatefulWidget {
//   const Setting({super.key});

//   @override
//   State<Setting> createState() => _Setting();
// }

// class _Setting extends State<Setting> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color.fromARGB(225, 7, 7, 27),
//         appBar: AppBar(
//           foregroundColor: Colors.white,
//           backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
//           // title: Text(
//           //   "data",
//           //   style: TextStyle(color: Colors.white),
//           // ),
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//             color: Colors.deepPurpleAccent.withOpacity(0.3),
//           ),
//           child: Column(children: [
//             Expanded(
//               flex: 1,
//               child: Padding(
//                 padding: EdgeInsets.only(left: 15),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Settings",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'TimesNewRoman',
//                           fontSize: 40),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//                 flex: 11,
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 21, 23, 31),
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(18),
//                         topRight: Radius.circular(18),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 25),
//                       child: ListView(
//                         children: [
//                           Padding(
//                               padding: EdgeInsets.only(left: 25),
//                               child: Text(
//                                 "GENERAL",
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 20),
//                               )),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               child: Icon(
//                                 Icons.person,
//                                 color: Colors.white,
//                                 size: 25,
//                               ),
//                             ),
//                             title: Text(
//                               'Persnal info',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                             // subtitle: Text('Name,e-mail,Number'),
//                             onTap: () {
//                               setState(() {
//                                 // Navigator.push(context,
//                                 //     MaterialPageRoute(builder: (context) => PersonInfo()));
//                               });
//                             },
//                           ),
//                           Divider(
//                             height: 1,
//                             thickness: 0,
//                             indent: 20,
//                             endIndent: 20,
//                           ),
//                           ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               child: Icon(Icons.chat_bubble,
//                                   color: Colors.white, size: 25),
//                             ),
//                             title: Text(
//                               'Manage Chat',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                             onTap: () {},
//                           ),
//                           Divider(
//                             height: 1,
//                             thickness: 0,
//                             indent: 20,
//                             endIndent: 20,
//                           ),
//                           ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               child: Icon(Icons.contact_support_rounded,
//                                   color: Colors.white, size: 25),
//                             ),
//                             title: Text(
//                               'Contact Support',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                             // subtitle: Text('Application detail,contac us'),
//                             onTap: () {
//                               // ContactSupportPage
//                               setState(() {
//                                 //   Navigator.push(context,
//                                 //       MaterialPageRoute(builder: (context) => ContactSupportPage()));
//                               });
//                             },
//                           ),
//                           Divider(
//                             height: 1,
//                             thickness: 0,
//                             indent: 20,
//                             endIndent: 20,
//                           ),
//                           ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               child: Icon(Icons.info,
//                                   color: Colors.white, size: 25),
//                             ),
//                             title: Text(
//                               'About Us',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                             // subtitle: Text('Application detail,contac us'),
//                             onTap: () {
//                               setState(
//                                 () {
//                                   // Navigator.push(context,
//                                   //     MaterialPageRoute(builder: (context) => AppDetail()));
//                                 },
//                               );
//                             },
//                           ),
//                           // Divider(
//                           //   height: 1,
//                           //   thickness: 0,
//                           //   indent: 20,
//                           //   endIndent: 20,
//                           // ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                               padding: EdgeInsets.only(left: 25),
//                               child: Text(
//                                 "FEEDBACK",
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 20),
//                               )),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               child: Icon(Icons.feedback_outlined,
//                                   color: Colors.white, size: 25),
//                             ),
//                             title: Text(
//                               'Seend Feedback ',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                             // subtitle: Text('Application detail,contac us'),
//                             onTap: () {
//                               // ContactSupportPage
//                               setState(() {
//                                 //   Navigator.push(context,
//                                 //       MaterialPageRoute(builder: (context) => ContactSupportPage()));
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ))
//           ]),
//         ));
//   }
// }

import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final List<String> _settingsOptions = [
    "GENERAL",
    "Personal Info",
    "Manage Chat",
    "Contact Support",
    "About Us",
    "FEEDBACK",
    "Send Feedback"
  ];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: 300), _insertItems);
  }

  void _insertItems() {
    for (int i = 0; i < _settingsOptions.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        _listKey.currentState?.insertItem(i);
      });
    }
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(225, 7, 7, 27),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent.withOpacity(0.3),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'TimesNewRoman',
                        fontSize: 40,
                      ),
                    ),
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
                    child: AnimatedList(
                      key: _listKey,
                      initialItemCount: 0,
                      itemBuilder: (context, index, animation) {
                        return SlideTransition(
                          position: animation.drive(Tween<Offset>(
                            begin: Offset(0, 1),
                            end: Offset(0, 0),
                          ).chain(CurveTween(curve: Curves.easeOut))),
                          child: _buildListItem(_settingsOptions[index]),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title) {
    if (title == "GENERAL" || title == "FEEDBACK") {
      return Padding(
        padding: EdgeInsets.only(left: 25, top: 15),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    }

    IconData icon;
    switch (title) {
      case "Personal Info":
        icon = Icons.person;
        break;
      case "Manage Chat":
        icon = Icons.chat_bubble;
        break;
      case "Contact Support":
        icon = Icons.contact_support_rounded;
        break;
      case "About Us":
        icon = Icons.info;
        break;
      case "Send Feedback":
        icon = Icons.feedback_outlined;
        break;
      default:
        icon = Icons.settings;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(icon, color: Colors.white, size: 25),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      onTap: () {
        switch (title) {
          case "Personal Info":
            print(title);
            break;
          case "Manage Chat":
            print(title);
            break;
          case "Contact Support":
            print(title);
            break;
          case "About Us":
            print(title);
            break;
          case "Send Feedback":
            print(title);
            break;
          default:
            print(title);
        }
      },
    );
  }
}
