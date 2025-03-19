// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// class FAQScreen extends StatefulWidget {
//   @override
//   _FAQScreenState createState() => _FAQScreenState();
// }

// class _FAQScreenState extends State<FAQScreen> {
//   List<Map<String, dynamic>> _faqList = [];

//   @override
//   void initState() {
//     super.initState();
//     loadFAQ();
//   }

//   Future<void> loadFAQ() async {
//     try {
//       var url = dotenv.env['URL']! + "getfaq";
//       var res = await http.get(Uri.parse(url));

//       var Jres = jsonDecode(res.body);
//       if (res.statusCode == 200) {
//         setState(() {
//           _faqList = List<Map<String, dynamic>>.from(Jres['faqs']);
//           print(_faqList);
//         });
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.black,
//         title: Text(
//           "FAQ",
//           style: GoogleFonts.poppins(
//             fontSize: 28, // Increased font size
//             fontWeight: FontWeight.bold,
//             color: Colors.white, // Set to white
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             // FAQ List
//             Expanded(
//               child: _faqList.isEmpty
//                   ? Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       itemCount: _faqList.length,
//                       itemBuilder: (context, index) {
//                         FAQItem(
//                           question: _faqList[index]["que"] ??
//                               "No question available", // Handle null case
//                           answer: _faqList[index]["ans"] ??
//                               "No answer available", // Handle null case
//                           isExpanded: _faqList[index]["isExpanded"] ??
//                               false, // Ensure it's not null
//                           onTap: () {
//                             setState(() {
//                               _faqList[index]["isExpanded"] =
//                                   !_faqList[index]["isExpanded"];
//                             });
//                           },
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FAQItem extends StatelessWidget {
//   final String question;
//   final String answer;
//   final bool isExpanded;
//   final VoidCallback onTap;

//   const FAQItem({
//     required this.question,
//     required this.answer,
//     required this.isExpanded,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.grey[900],
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         children: [
//           ListTile(
//             title: Text(
//               question,
//               style: GoogleFonts.poppins(
//                 fontSize: 20, // Increased font size
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//             trailing: Icon(
//               isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//               color: Colors.white,
//               size: 28, // Bigger icon
//             ),
//             onTap: onTap,
//           ),
//           if (isExpanded)
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Text(
//                 answer,
//                 style: GoogleFonts.poppins(
//                   fontSize: 18, // Bigger answer text
//                   color: Colors.white.withOpacity(0.85),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<Map<String, dynamic>> _faqList = [];

  @override
  void initState() {
    super.initState();
    loadFAQ();
  }

  Future<void> loadFAQ() async {
    try {
      var url = dotenv.env['URL']! + "getfaq";
      var res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        var Jres = jsonDecode(res.body);
        setState(() {
          _faqList = List<Map<String, dynamic>>.from(Jres['faqs']);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          "FAQ",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: _faqList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _faqList.length,
                      itemBuilder: (context, index) {
                        return FAQItem(
                          question:
                              _faqList[index]["que"] ?? "No question available",
                          answer:
                              _faqList[index]["ans"] ?? "No answer available",
                          isExpanded: _faqList[index]["isExpanded"],
                          onTap: () {
                            setState(() {
                              _faqList[index]["isExpanded"] =
                                  !_faqList[index]["isExpanded"];
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const FAQItem({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ListTile(
            title: Text(
              question,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 28,
            ),
            onTap: onTap,
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                answer,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
