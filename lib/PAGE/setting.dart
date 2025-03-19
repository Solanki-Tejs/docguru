import 'package:docguru/PAGE/AboutUs.dart';
import 'package:docguru/PAGE/FAQ.dart';
import 'package:docguru/PAGE/Feedback.dart';
import 'package:docguru/PAGE/Profile.dart';
import 'package:docguru/PAGE/contact_us.dart';
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
    "FAQ",
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
      backgroundColor: Color.fromARGB(224, 0, 0, 0),
      appBar: AppBar(
        foregroundColor: Colors.white,
        // backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          // color: Colors.deepPurpleAccent.withOpacity(0.3),
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
                        // fontFamily: 'TimesNewRoman',
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
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
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
      case "FAQ":
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
            // print(title);
            break;
          case "FAQ":
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FAQScreen()));
            break;
          case "Contact Support":
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContactUsPage()));
            break;
          case "About Us":
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutUsPage()));
            // print(title);
            break;
          case "Send Feedback":
            // print(title);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FeedbackScreen()));
            break;
          default:
            print(title);
        }
      },
    );
  }
}
