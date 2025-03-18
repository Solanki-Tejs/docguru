// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String username = "John Doe";
//   String email = "johndoe@example.com";
//   String password = "********";
//   String selectedProfilePic = "assets/profile1.png"; // Default profile picture

//   bool isEditingUsername = false;
//   bool isEditingEmail = false;
//   bool isEditingPassword = false;

//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   List<String> profileImages = [
//     "assets/p1.png",
//     "assets/p2.png",
//     "assets/p3.png",
//     "assets/p4.png",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     loaddata();
//   }

//   Future<void> loaddata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       username = prefs.getString("userName") ?? "John Doe";
//       email = prefs.getString("email") ?? "johndoe@example.com";
//       selectedProfilePic = prefs.getString("profilePic") ?? "assets/p1.png";
//     });
//   }

//   void _toggleEdit(String field) {
//     setState(() {
//       if (field == "Username") {
//         isEditingUsername = !isEditingUsername;
//         if (isEditingUsername) {
//           usernameController.text = username;
//         } else {
//           username = usernameController.text;
//         }
//       } else if (field == "Email") {
//         isEditingEmail = !isEditingEmail;
//         if (isEditingEmail) {
//           emailController.text = email;
//         } else {
//           email = emailController.text;
//         }
//       } else if (field == "Password") {
//         isEditingPassword = !isEditingPassword;
//         if (isEditingPassword) {
//           passwordController.text = password;
//         } else {
//           password = passwordController.text;
//         }
//       }
//     });
//   }

//   void _changeProfilePicture() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Select Profile Picture"),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: GridView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//             ),
//             itemCount: profileImages.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedProfilePic = profileImages[index];
//                     prefs.setString("profilePic", selectedProfilePic);
//                   });
//                   Navigator.pop(context);
//                 },
//                 child: Image.asset(profileImages[index], fit: BoxFit.cover),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     double scrheight = size.height;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Center(
//           child: Container(
//             padding: EdgeInsets.only(top: scrheight * 0.05),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 75,
//                       backgroundColor: Colors.white,
//                       backgroundImage: AssetImage(selectedProfilePic),
//                     ),
//                     Positioned(
//                       bottom: -5,
//                       right: -5,
//                       child: Container(
//                         height: 45,
//                         width: 45,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.black, width: 5)),
//                         child: IconButton(
//                           onPressed: _changeProfilePicture,
//                           icon: Icon(
//                             Icons.edit,
//                             color: Colors.black,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 50),
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   margin: EdgeInsets.symmetric(horizontal: 25),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       profileInfoTile("Username", username, isEditingUsername,
//                           usernameController),
//                       Divider(color: Colors.white54),
//                       profileInfoTile(
//                           "Email", email, isEditingEmail, emailController),
//                       Divider(color: Colors.white54),
//                       profileInfoTile("Password", password, isEditingPassword,
//                           passwordController),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget profileInfoTile(String title, String value, bool isEditing,
//       TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//         SizedBox(height: 4),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: isEditing
//                   ? TextField(
//                       controller: controller,
//                       obscureText: title == "Password",
//                       autofocus: true,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                       ),
//                     )
//                   : Text(
//                       value,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     ),
//             ),
//             if (title != "Password")
//               IconButton(
//                 onPressed: () => _toggleEdit(title),
//                 icon: Icon(isEditing ? Icons.done : Icons.edit,
//                     color: Colors.white70, size: 20),
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> loaddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token=prefs.getString("token");
    setState(() {
      username = prefs.getString("userName") ?? "John Doe";
      email = prefs.getString("email") ?? "johndoe@example.com";
      selectedProfilePic = prefs.getString("profilePic_${token}") ?? "assets/p1.png";
      pass=prefs.getString("pass");
    });
  }

  void _toggleEdit(String field) {
    setState(() {
      if (field == "Username") {
        isEditingUsername = !isEditingUsername;
        if (isEditingUsername) {
          usernameController.text = username;
        } else {
          username = usernameController.text;
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
                      Navigator.pop(context);
                      setState(() {
                        // setdata();
                        passwordController.clear();
                      });
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
                                onPressed: () => _toggleEdit("UserName"),
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
