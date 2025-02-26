// // ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, file_names, camel_case_types

// import 'dart:ui';

// import 'package:docguru/PAGE/ChatPage.dart';
// import 'package:docguru/PAGE/SignIn.dart';
// import 'package:docguru/PAGE/UploadFile.dart';
// import 'package:docguru/PAGE/setting.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   Future<void> logout() async {
//     print("object");
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var token = pref.getString("token");
//     print(token);
//     await pref.remove('token');

//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const SignIn()),
//         (Route) => false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     //screen size
//     final Size size = MediaQuery.sizeOf(context);
//     //Screen width
//     double scrwidth = size.width;
//     //Screen hight
//     double scrheight = size.height;
//     print(scrheight);
//     print(scrwidth);
//     return Scaffold(
//         // backgroundColor: Colors.transparent,
//         backgroundColor: Color.fromARGB(225, 7, 7, 27),
//         appBar: AppBar(
//           foregroundColor: Colors.white,
//           backgroundColor: Colors.transparent,
//           title: Text(
//             "DocGuru",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         drawer: Drawer(
//           width: scrwidth / 1.2,
//           backgroundColor: Colors.transparent,
//           child: ClipRRect(
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(16),
//               bottomRight: Radius.circular(16),
//             ),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//               child: Container(
//                 color: const Color.fromARGB(255, 64, 63, 63).withOpacity(0.3),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: scrheight / 8,
//                       child: DrawerHeader(
//                         decoration: BoxDecoration(
//                           color: Colors.deepPurpleAccent,
//                         ),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "DocGuru",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView(
//                         padding: EdgeInsets.zero,
//                         children: [
//                           ListTile(
//                             // hoverColor: Colors.deepPurpleAccent,
//                             splashColor: Colors.deepPurpleAccent,
//                             // selectedColor: Colors.deepPurpleAccent,
//                             // tileColor: Colors.deepPurpleAccent,
//                             // focusColor: Colors.deepPurpleAccent,
//                             // selectedTileColor: Colors.deepPurpleAccent,
//                             leading: Icon(Icons.description_outlined,
//                                 color: Colors.white),
//                             title: Text("PDF name",
//                                 style: TextStyle(color: Colors.white)),
//                             onTap: () {},
//                           ),
//                           // Add more menu items as needed.
//                         ],
//                       ),
//                     ),
//                     Divider(color: Colors.white70, thickness: 0.5),
//                     Column(
//                       children: [
//                         ListTile(
//                           leading: Icon(Icons.settings, color: Colors.white),
//                           title: Text(
//                             'Settings',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Setting()));
//                           },
//                         ),
//                         ListTile(
//                           leading: Icon(Icons.logout, color: Colors.white),
//                           title: Text(
//                             'Log Out',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           onTap: () {
//                             logout();
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         body: UploadFile());
//   }
// }

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:docguru/PAGE/ChatPage.dart';
// import 'package:docguru/PAGE/SignIn.dart';
// import 'package:docguru/PAGE/UploadFile.dart';
// import 'package:docguru/PAGE/setting.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   bool pdfUploaded = false;

//   @override
//   void initState() {
//     super.initState();
//     checkPdfUploaded();
//   }

//   Future<void> checkPdfUploaded() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     setState(() {
//       pdfUploaded = pref.getBool("pdfUploaded") ?? false;
//     });
//   }

//   Future<void> logout() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.remove('token');
//     await pref.remove('pdfUploaded'); // Clear PDF upload status on logout

//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const SignIn()),
//       (Route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     double scrwidth = size.width;
//     double scrheight = size.height;

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(225, 7, 7, 27),
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.transparent,
//         title: const Text(
//           "DocGuru",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       drawer: Drawer(
//         width: scrwidth / 1.2,
//         backgroundColor: Colors.transparent,
//         child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topRight: Radius.circular(16),
//             bottomRight: Radius.circular(16),
//           ),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//             child: Container(
//               color: const Color.fromARGB(255, 64, 63, 63).withOpacity(0.3),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: scrheight / 8,
//                     child: const DrawerHeader(
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurpleAccent,
//                       ),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           "DocGuru",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView(
//                       padding: EdgeInsets.zero,
//                       children: [
//                         ListTile(
//                           splashColor: Colors.deepPurpleAccent,
//                           leading: const Icon(Icons.description_outlined,
//                               color: Colors.white),
//                           title: const Text("PDF name",
//                               style: TextStyle(color: Colors.white)),
//                           onTap: () {},
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(color: Colors.white70, thickness: 0.5),
//                   Column(
//                     children: [
//                       ListTile(
//                         leading:
//                             const Icon(Icons.settings, color: Colors.white),
//                         title: const Text(
//                           'Settings',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Setting()));
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.logout, color: Colors.white),
//                         title: const Text(
//                           'Log Out',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onTap: () {
//                           logout();
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: pdfUploaded ? ChatPage() : UploadFile(),
//     );
//   }
// }

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:docguru/PAGE/ChatPage.dart';
// import 'package:docguru/PAGE/SignIn.dart';
// import 'package:docguru/PAGE/UploadFile.dart';
// import 'package:docguru/PAGE/setting.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   bool pdfUploaded = false;

//   @override
//   void initState() {
//     super.initState();
//     checkPdfUploaded();
//   }

//   Future<void> checkPdfUploaded() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     setState(() {
//       pdfUploaded = pref.getBool("pdfUploaded") ?? false;
//     });
//   }

//   Future<void> logout() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.remove('token');
//     await pref.remove('pdfUploaded'); // Clear PDF upload status on logout

//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const SignIn()),
//       (Route) => false,
//     );
//   }

//   // Function to navigate to UploadFile page to upload another PDF
//   void uploadAnotherPDF() async {
//     // Optionally, clear previous PDF status if you want to force a new upload
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setBool("pdfUploaded", false);
//     // Navigate to the UploadFile page
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => UploadFile()),
//     ).then((_) {
//       // Refresh status after coming back from the upload screen
//       checkPdfUploaded();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     double scrwidth = size.width;
//     double scrheight = size.height;

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(225, 7, 7, 27),
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.transparent,
//         title: const Text(
//           "DocGuru",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       drawer: Drawer(
//         width: scrwidth / 1.2,
//         backgroundColor: Colors.transparent,
//         child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topRight: Radius.circular(16),
//             bottomRight: Radius.circular(16),
//           ),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//             child: Container(
//               color: const Color.fromARGB(255, 64, 63, 63).withOpacity(0.3),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: scrheight / 8,
//                     child: const DrawerHeader(
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurpleAccent,
//                       ),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           "DocGuru",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView(
//                       padding: EdgeInsets.zero,
//                       children: [
//                         ListTile(
//                           splashColor: Colors.deepPurpleAccent,
//                           leading: const Icon(Icons.description_outlined,
//                               color: Colors.white),
//                           title: const Text("PDF name",
//                               style: TextStyle(color: Colors.white)),
//                           onTap: () {
//                             // You might want to show details about the current PDF
//                           },
//                         ),
//                         ListTile(
//                           splashColor: Colors.deepPurpleAccent,
//                           leading: const Icon(Icons.upload_file,
//                               color: Colors.white),
//                           title: const Text("Upload Another PDF",
//                               style: TextStyle(color: Colors.white)),
//                           onTap: () {
//                             uploadAnotherPDF();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(color: Colors.white70, thickness: 0.5),
//                   Column(
//                     children: [
//                       ListTile(
//                         leading:
//                             const Icon(Icons.settings, color: Colors.white),
//                         title: const Text(
//                           'Settings',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Setting()));
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.logout, color: Colors.white),
//                         title: const Text(
//                           'Log Out',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onTap: () {
//                           logout();
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       // Display ChatPage if a PDF is already uploaded, otherwise show UploadFile page.
//       body: pdfUploaded ? ChatPage() : UploadFile(),
//     );
//   }
// }

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:docguru/PAGE/ChatPage.dart';
// import 'package:docguru/PAGE/SignIn.dart';
// import 'package:docguru/PAGE/UploadFile.dart';
// import 'package:docguru/PAGE/setting.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   bool pdfUploaded = false;
//   String? pdfName;

//   @override
//   void initState() {
//     super.initState();
//     checkPdfStatus();
//   }

//   // Check both PDF upload status and PDF name from SharedPreferences
//   Future<void> checkPdfStatus() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     setState(() {
//       pdfUploaded = pref.getBool("pdfUploaded") ?? false;
//       pdfName = pref.getString("pdfName") ?? "No PDF uploaded";
//     });
//   }

//   Future<void> logout() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.remove('token');
//     await pref.remove('pdfUploaded');
//     await pref.remove('pdfName');

//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const SignIn()),
//       (Route) => false,
//     );
//   }

//   // Function to navigate to UploadFile page to upload another PDF.
//   void uploadAnotherPDF() async {
//     // Optionally, clear previous PDF status if you want to force a new upload
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setBool("pdfUploaded", false);
//     await pref.remove("pdfName");
//     // Navigate to the UploadFile page
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => UploadFile()),
//     ).then((_) {
//       // Refresh status after coming back from the upload screen
//       checkPdfStatus();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     double scrwidth = size.width;
//     double scrheight = size.height;

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(225, 7, 7, 27),
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.transparent,
//         title: const Text(
//           "DocGuru",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       drawer: Drawer(
//         width: scrwidth / 1.2,
//         backgroundColor: Colors.transparent,
//         child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topRight: Radius.circular(16),
//             bottomRight: Radius.circular(16),
//           ),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//             child: Container(
//               color: const Color.fromARGB(255, 64, 63, 63).withOpacity(0.3),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: scrheight / 8,
//                     child: DrawerHeader(
//                       decoration: const BoxDecoration(
//                         color: Colors.deepPurpleAccent,
//                       ),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           // Display the PDF name here.
//                           pdfName ?? "No PDF uploaded",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView(
//                       padding: EdgeInsets.zero,
//                       children: [
//                         ListTile(
//                           splashColor: Colors.deepPurpleAccent,
//                           leading: const Icon(Icons.description_outlined,
//                               color: Colors.white),
//                           title: Text(
//                             pdfName ?? "No PDF uploaded",
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           onTap: () {
//                             // Optionally, display more details about the PDF
//                           },
//                         ),
//                         ListTile(
//                           splashColor: Colors.deepPurpleAccent,
//                           leading: const Icon(Icons.upload_file,
//                               color: Colors.white),
//                           title: const Text("Upload Another PDF",
//                               style: TextStyle(color: Colors.white)),
//                           onTap: () {
//                             uploadAnotherPDF();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(color: Colors.white70, thickness: 0.5),
//                   Column(
//                     children: [
//                       ListTile(
//                         leading:
//                             const Icon(Icons.settings, color: Colors.white),
//                         title: const Text(
//                           'Settings',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => Setting()),
//                           );
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.logout, color: Colors.white),
//                         title: const Text(
//                           'Log Out',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onTap: () {
//                           logout();
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       // Display ChatPage if a PDF is already uploaded, otherwise show UploadFile page.
//       body: pdfUploaded ? ChatPage() : UploadFile(),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:docguru/PAGE/ChatPage.dart';
import 'package:docguru/PAGE/SignIn.dart';
import 'package:docguru/PAGE/UploadFile.dart';
import 'package:docguru/PAGE/setting.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool pdfUploaded = false;
  String? pdfName;
  List<String> pdfList = []; // List for multiple PDFs

  @override
  void initState() {
    super.initState();
    checkPdfStatus();
  }

  Future<void> checkPdfStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pdfUploaded = pref.getBool("pdfUploaded") ?? false;
      pdfName = pref.getString("pdfName") ?? "No PDF uploaded";
      pdfList = pref.getStringList("pdfList") ?? [];
    });
  }

  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
      (Route) => false,
    );
  }

  void uploadAnotherPDF() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("pdfUploaded", false);
    await pref.remove("pdfName");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadFile()),
    ).then((_) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? newPdfName = pref.getString("pdfName");
      if (newPdfName != null && !pdfList.contains(newPdfName)) {
        pdfList.add(newPdfName);
        await pref.setStringList("pdfList", pdfList);
      }
      checkPdfStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    double scrwidth = size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 7, 7, 27),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        title: const Text(
          "DocGuru",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        width: scrwidth / 1.2,
        backgroundColor: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: const Color.fromARGB(255, 64, 63, 63).withOpacity(0.3),
            child: ListView(
              children: [
                DrawerHeader(
                  decoration:
                      const BoxDecoration(color: Colors.deepPurpleAccent),
                  child: Text(
                    pdfName ?? "No PDF uploaded",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                ...pdfList.map((pdf) => ListTile(
                      splashColor: Colors.deepPurpleAccent,
                      leading: const Icon(Icons.description_outlined,
                          color: Colors.white),
                      title: Text(pdf,
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {},
                    )),
                const Divider(color: Colors.white70, thickness: 0.5),
                ListTile(
                  leading: const Icon(Icons.upload_file, color: Colors.white),
                  title: const Text('Upload PDF',
                      style: TextStyle(color: Colors.white)),
                  onTap: uploadAnotherPDF,
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text('Settings',
                      style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Setting())),
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text('Log Out',
                      style: TextStyle(color: Colors.white)),
                  onTap: logout,
                ),
              ],
            ),
          ),
        ),
      ),
      body: pdfUploaded ? ChatPage() : UploadFile(),
    );
  }
}
