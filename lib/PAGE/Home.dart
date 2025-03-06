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
//   List<String> pdfList = []; // List for multiple PDFs

//   @override
//   void initState() {
//     super.initState();
//     checkPdfStatus();
//   }

//   Future<void> checkPdfStatus() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     setState(() {
//       pdfUploaded = pref.getBool("pdfUploaded") ?? false;
//       pdfName = pref.getString("pdfName") ?? "No PDF uploaded";
//       pdfList = pref.getStringList("pdfList") ?? [];
//     });
//   }

//   Future<void> logout() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.clear();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const SignIn()),
//       (Route) => false,
//     );
//   }

//   void uploadAnotherPDF() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setBool("pdfUploaded", false);
//     await pref.remove("pdfName");

//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => UploadFile()),
//     ).then((_) async {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       String? newPdfName = pref.getString("pdfName");
//       if (newPdfName != null && !pdfList.contains(newPdfName)) {
//         pdfList.add(newPdfName);
//         await pref.setStringList("pdfList", pdfList);
//       }
//       checkPdfStatus();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     double scrwidth = size.width;

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
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//           child: Container(
//             color: const Color.fromARGB(255, 64, 63, 63).withOpacity(0.3),
//             child: ListView(
//               children: [
//                 DrawerHeader(
//                   decoration:
//                       const BoxDecoration(color: Colors.deepPurpleAccent),
//                   child: Text(
//                     pdfName ?? "No PDF uploaded",
//                     style: const TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//                 ...pdfList.map((pdf) => ListTile(
//                       splashColor: Colors.deepPurpleAccent,
//                       leading: const Icon(Icons.description_outlined,
//                           color: Colors.white),
//                       title: Text(pdf,
//                           style: const TextStyle(color: Colors.white)),
//                       onTap: () {},
//                     )),
//                 const Divider(color: Colors.white70, thickness: 0.5),
//                 ListTile(
//                   leading: const Icon(Icons.upload_file, color: Colors.white),
//                   title: const Text('Upload PDF',
//                       style: TextStyle(color: Colors.white)),
//                   onTap: uploadAnotherPDF,
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.settings, color: Colors.white),
//                   title: const Text('Settings',
//                       style: TextStyle(color: Colors.white)),
//                   onTap: () => Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Setting())),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.logout, color: Colors.white),
//                   title: const Text('Log Out',
//                       style: TextStyle(color: Colors.white)),
//                   onTap: logout,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: pdfUploaded ? ChatPage() : UploadFile(),
//     );
//   }
// }

import 'dart:ui';

import 'package:docguru/PAGE/SignIn.dart';
import 'package:docguru/PAGE/setting.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:docguru/PAGE/ChatPage.dart';
import 'package:docguru/PAGE/UploadFile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> pageNames = [];
  List<String> CollactionNames = [];
  List<List<String>> chatMessages = [];
  List<bool> uploadStatuses = [];
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    loadPages();
  }

  // Loading pages and chat messages from SharedPreferences
  Future<void> loadPages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int pageCount = prefs.getInt('page_count') ?? 0;
    int? onPage=prefs.getInt("onPage") ?? 0;
    List<String> loadedPageNames = [];
    List<String> loadedCollactionNames = [];
    List<bool> loadedUploadStatuses = [];
    List<List<String>> loadedChatMessages = [];

    for (int i = 0; i < pageCount; i++) {
      loadedCollactionNames.add(prefs.getString('CollactionNames_${i}_name') ??
          "CollactionNames ${i + 1}");
      loadedPageNames.add(prefs.getString('page_${i}_name') ?? "Page ${i + 1}");

      loadedUploadStatuses
          .add(prefs.getBool('page_${i}_upload_status') ?? false);
      loadedChatMessages.add(prefs.getStringList('page_${i}_messages') ??
          []); // Loading the chat messages
    }

    setState(() {
      CollactionNames = loadedCollactionNames;
      pageNames = loadedPageNames;

      uploadStatuses = loadedUploadStatuses;
      chatMessages = loadedChatMessages;
      currentPageIndex = pageNames.isEmpty ? 0 : onPage;
    });
  }

  // Add a new page and initialize chat messages
  void addPage() {
    setState(() {
      CollactionNames.add("CollactionNames ${CollactionNames.length + 1}");
      pageNames.add("Page ${pageNames.length + 1}");

      uploadStatuses.add(false);
      chatMessages.add([]); // Initialize empty chat messages for the new page
      currentPageIndex = pageNames.length - 1; // Switch to the new page
      savePages();
    });
  }

  // Save pages and chat messages to SharedPreferences
  void savePages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page_count', pageNames.length);

    for (int i = 0; i < pageNames.length; i++) {
      prefs.setString('page_${i}_name', pageNames[i]);
      prefs.setString('CollactionNames_${i}_name', CollactionNames[i]);
      prefs.setBool('page_${i}_upload_status', uploadStatuses[i]);
      prefs.setStringList(
          'page_${i}_messages', chatMessages[i]); // Save chat messages
    }
  }

  // Switch between pages
  void switchPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  // Update chat messages for the current page
  void addMessage(int pageIndex, String message) {
    setState(() {
      chatMessages[pageIndex].add(message);
    });
    savePages(); // Save after adding message
  }

  // Toggle upload status for the current page
  void toggleUploadStatus(int pageIndex) {
    setState(() {
      uploadStatuses[pageIndex] = !uploadStatuses[pageIndex];
    });
    savePages();
  }

  // Set the page name
  void setPageName(int pageIndex, String name, String Filename) {
    setState(() {
      CollactionNames[pageIndex] = Filename;
      pageNames[pageIndex] = name;
      print(CollactionNames);
    });
    savePages();
  }

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
      backgroundColor: Color.fromARGB(225, 7, 7, 27),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        title: const Text("DocGuru", style: TextStyle(color: Colors.white)),
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
                        for (int i = 0; i < pageNames.length; i++)
                          ListTile(
                            title: Text(pageNames[i],
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              switchPage(i);
                              Navigator.pop(context); // Close the drawer
                            },
                          ),
                        // ListTile(
                        //   leading: Icon(Icons.add),
                        //   title: Text("Add Page",style: TextStyle(color: Colors.white)),
                        //   onTap: () {
                        //     addPage();
                        //     Navigator.pop(context); // Close the drawer
                        //   },
                        // ),
                        // Add more menu items as needed.
                      ],
                    ),
                  ),
                  Divider(color: Colors.white70, thickness: 0.5),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.add, color: Colors.white),
                        title: Text("Add Page",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          addPage();
                          Navigator.pop(context); // Close the drawer
                        },
                      ),
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
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       DrawerHeader(
      //         decoration: BoxDecoration(color: Colors.deepPurpleAccent),
      //         child: Align(
      //           alignment: Alignment.centerLeft,
      //           child: Text("DocGuru", style: TextStyle(color: Colors.white)),
      //         ),
      //       ),
      //       // List of pages
      //       for (int i = 0; i < pageNames.length; i++)
      //         ListTile(
      //           title: Text(pageNames[i]),
      //           onTap: () {
      //             switchPage(i);
      //             Navigator.pop(context); // Close the drawer
      //           },
      //         ),
      //       ListTile(
      //         leading: Icon(Icons.add),
      //         title: Text("Add Page"),
      //         onTap: () {
      //           addPage();
      //           Navigator.pop(context); // Close the drawer
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: Builder(
        builder: (context) {
          // Display the current page, with upload status checked
          return pageNames.isEmpty
              ? Center(
                  child:
                      Text("No Pages Created", style: TextStyle(fontSize: 24)))
              : uploadStatuses[currentPageIndex]
                  ? ChatPage(
                    pageName: pageNames[currentPageIndex],
                      pageIndex: currentPageIndex,
                      messages: chatMessages[currentPageIndex],
                      onMessagesUpdated: (updatedMessages) {
                        setState(() {
                          chatMessages[currentPageIndex] = updatedMessages;
                        });
                        savePages(); // Save updated messages
                      },
                    ) // Chat page if upload is complete
                  : UploadFile(
                      toggleUploadStatus: () =>
                          toggleUploadStatus(currentPageIndex),
                      pageIndex: currentPageIndex,
                      onNameChange: (name, Filename) =>
                          setPageName(currentPageIndex, name, Filename),
                    ); // Upload page otherwise
        },
      ),
    );
  }
}
