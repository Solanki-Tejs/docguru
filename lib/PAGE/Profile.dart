import 'dart:convert';
import 'package:docguru/PAGE/newpass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "John Doe";
  String email = "johndoe@example.com";
  String password = "********";
  String selectedProfilePic = "assets/p1.png";
  bool isEditingUsername = false;
  bool _obscureText = true;
  var pass;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<String> profileImages = [
    "assets/p1.png",
    "assets/p2.png",
    "assets/p3.png",
    "assets/p4.png",
  ];

  var token;

  @override
  void initState() {
    super.initState();
    loaddata();
  }

  Future<void> navigateToResetPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Newpass(email: email, pagename: "Profile"),
      ),
    );

    if (result == true) {
      print("back to profile page");
      setState(() {
        pass = prefs.getString("pass");
        print("In profile page ${pass}");
      });
    }
  }

  Future<void> loaddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    setState(() {
      username = prefs.getString("userName") ?? "John Doe";
      email = prefs.getString("email") ?? "johndoe@example.com";
      selectedProfilePic =
          prefs.getString("profilePic_${token}") ?? "assets/p1.png";
      pass = prefs.getString("pass");
    });
    print(selectedProfilePic);
  }

  void _toggleEdit(String field) {
    setState(() {
      if (field == "Username") {
        isEditingUsername = !isEditingUsername;
        if (isEditingUsername) {
          usernameController.text = username;
        } else {
          updateUserName(usernameController.text);
        }
      } else if (field == "Password") {
        _showConfirmPasswordDialog();
      }
    });
  }

  void _showConfirmPasswordDialog() {
    String errorText = "";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Text("Confirm Password",
                  style: TextStyle(color: Colors.black)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Please enter your password to continue.",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                          size: 26,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      hintText: "Enter your password",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: errorText.isNotEmpty ? errorText : null,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    passwordController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    if (passwordController.text.isEmpty) {
                      setDialogState(() {
                        errorText = "Password cannot be empty!";
                      });
                    } else if (passwordController.text != pass) {
                      setDialogState(() {
                        errorText = "Incorrect password. Try again.";
                      });
                    } else {
                      print("Password correct");
                      Navigator.pop(context);
                      setState(() {
                        // setdata();
                        passwordController.clear();
                      });
                      navigateToResetPassword();
                    }
                  },
                  child: Text("Confirm", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _changeProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Profile Picture"),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: profileImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedProfilePic = profileImages[index];
                    prefs.setString("profilePic_${token}", selectedProfilePic);
                  });
                  Navigator.pop(context);
                },
                child: Image.asset(profileImages[index], fit: BoxFit.cover),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> updateUserName(userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {"token": token, "updatedName": userName};

    try {
      var url = dotenv.env['URL']! + "updateUserName";
      var res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      var Jres = jsonDecode(res.body);

      if (res.statusCode == 200) {
        print(userName);
        print(username);
        setState(() {
          prefs.setString("userName", userName);
          username = userName;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Details don’t match'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    double scrheight = size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: scrheight * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(selectedProfilePic),
                    ),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 5)),
                        child: IconButton(
                          onPressed: _changeProfilePicture,
                          icon: Icon(Icons.edit, color: Colors.black, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "UserName",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: isEditingUsername
                                    ? TextField(
                                        controller: usernameController,
                                        autofocus: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
                                      )
                                    : Text(
                                        username,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                              IconButton(
                                onPressed: () => _toggleEdit("Username"),
                                icon: Icon(
                                    isEditingUsername ? Icons.done : Icons.edit,
                                    color: Colors.white70,
                                    size: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: Colors.white54),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  email,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: Colors.white54),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Password",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "********",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _toggleEdit("Password"),
                                icon: Icon(Icons.edit,
                                    color: Colors.white70, size: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
