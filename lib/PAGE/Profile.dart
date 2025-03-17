// import 'package:flutter/material.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     double scrwidth = size.width;
//     double scrheight = size.height;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Center(
//         child: Container(
//           padding: EdgeInsets.only(top: scrheight * 0.05),
//           decoration: BoxDecoration(),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 75,
//                     child: Icon(
//                       Icons.person,
//                       size: 105,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: -5, // Aligns at the bottom
//                     right: -5, // Aligns at the right
//                     child: Container(
//                       height: 45,
//                       width: 45,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.black, width: 5)),
//                       child: IconButton(
//                         onPressed: () {},
//                         icon: Icon(
//                           Icons.edit,
//                           color: Colors.black,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 75,
//               ),
//               Container(
//                 // width: double.infinity,
//                 // height: double.infinity,
//                 padding: EdgeInsets.all(12),
//                 margin: EdgeInsets.symmetric(horizontal: 25),
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(12)),
//                 child: Column(
//                   children: [

//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

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
//       body: Center(
//         child: Container(
//           padding: EdgeInsets.only(top: scrheight * 0.05),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 75,
//                     backgroundColor: Colors.white,
//                     child: Icon(
//                       Icons.person,
//                       size: 105,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: -5,
//                     right: -5,
//                     child: Container(
//                       height: 45,
//                       width: 45,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.black, width: 5)),
//                       child: IconButton(
//                         onPressed: () {},
//                         icon: Icon(
//                           Icons.edit,
//                           color: Colors.black,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 50),
//               Container(
//                 padding: EdgeInsets.all(16),
//                 margin: EdgeInsets.symmetric(horizontal: 25),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     profileInfoTile("Username", "John Doe"),
//                     Divider(color: Colors.white54),
//                     profileInfoTile("Email", "johndoe@example.com"),
//                     Divider(color: Colors.white54),
//                     profileInfoTile("Password", "********"),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget profileInfoTile(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(color: Colors.white70, fontSize: 14),
//           ),
//           SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//                 color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "John Doe";
  String email = "johndoe@example.com";
  String password = "********";

  bool isEditingUsername = false;
  bool isEditingEmail = false;
  bool isEditingPassword = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _toggleEdit(String field) {
    setState(() {
      if (field == "Username") {
        isEditingUsername = !isEditingUsername;
        if (isEditingUsername) {
          usernameController.text = username;
        } else {
          username = usernameController.text;
        }
      } else if (field == "Email") {
        isEditingEmail = !isEditingEmail;
        if (isEditingEmail) {
          emailController.text = email;
        } else {
          email = emailController.text;
        }
      } else if (field == "Password") {
        isEditingPassword = !isEditingPassword;
        if (isEditingPassword) {
          passwordController.text = password;
        } else {
          password = passwordController.text;
        }
      }
    });
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
                      child: Icon(
                        Icons.person,
                        size: 105,
                        color: Colors.black,
                      ),
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
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 20,
                          ),
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
                      profileInfoTile("Username", username, isEditingUsername,
                          usernameController),
                      Divider(color: Colors.white54),
                      profileInfoTile(
                          "Email", email, isEditingEmail, emailController),
                      Divider(color: Colors.white54),
                      profileInfoTile("Password", password, isEditingPassword,
                          passwordController),
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

  Widget profileInfoTile(String title, String value, bool isEditing,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: isEditing
                  ? TextField(
                      controller: controller,
                      obscureText: title == "Password",
                      autofocus: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // focusedBorder: UnderlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.white70)),
                      ),
                    )
                  : Text(
                      value,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            if (title != "Password")
              IconButton(
                onPressed: () => _toggleEdit(title),
                icon: Icon(isEditing ? Icons.done : Icons.edit,
                    color: Colors.white70, size: 20),
              ),
          ],
        ),
      ],
    );
  }
}
