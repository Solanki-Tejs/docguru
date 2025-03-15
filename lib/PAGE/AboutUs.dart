// import 'package:flutter/material.dart';

// class AboutUsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black, // Darker background for contrast
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Back Button (Top Left)
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: IconButton(
//                   icon: Icon(Icons.arrow_back, color: Colors.white, size: 42),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),

//               // 3D Styled Icon
//               Container(
//                 padding: EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.black, // Slightly lighter than background
//                 ),
//                 child: Icon(Icons.info, size: 80, color: Colors.white),
//               ),
//               SizedBox(height: 15),

//               // Title - Adjusted Upper Slightly
//               Text(
//                 "About Us",
//                 style: TextStyle(
//                   fontSize: 24, // Slightly smaller for balance
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.2,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 15),

//               // Paragraph - Enhanced & Justified
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: SingleChildScrollView(
//                     physics: BouncingScrollPhysics(),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "We are committed to revolutionizing the way students learn and prepare for exams by leveraging AI technology. Our project utilizes LangChain, a powerful tool for integrating large language models (LLMs), along with Python, to build an advanced AI-powered Question Answering (QA) system. This intelligent agent is designed to analyze and process documents, particularly PDFs, extracting key information and summarizing answers efficiently.\n\n"
//                         "Integrated into a user-friendly Flutter app, our solution provides students with an interactive and seamless experience. By enabling quick access to relevant answers, it streamlines study sessions, making learning more effective and reducing the time spent searching for information. Our AI-driven approach ensures that students can focus on understanding concepts rather than manually sifting through extensive study materials.\n\n"
//                         "Our mission is to enhance academic success by simplifying the learning process. By offering a smarter way to study, we empower students to stay organized, improve retention, and achieve their educational goals with greater ease.",
//                         style: TextStyle(
//                           fontSize: 18, // Enhanced readability
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white70,
//                           height: 1.6,
//                         ),
//                         textAlign: TextAlign.left, // **Perfect Alignment**
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF2E2E2E), // Slightly greyish background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 500, // Increased width for better readability
          padding: EdgeInsets.all(40), // Spacious padding
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.info, size: 80, color: Colors.white),
              SizedBox(height: 20),
              Text(
                "About Us",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "We are committed to revolutionizing the way students learn and prepare for exams by leveraging AI technology. Our project utilizes LangChain, a powerful tool for integrating large language models (LLMs), along with Python, to build an advanced AI-powered Question Answering (QA) system. This intelligent agent is designed to analyze and process documents, particularly PDFs, extracting key information and summarizing answers efficiently.\n\n"
                        "Integrated into a user-friendly Flutter app, our solution provides students with an interactive and seamless experience. By enabling quick access to relevant answers, it streamlines study sessions, making learning more effective and reducing the time spent searching for information. Our AI-driven approach ensures that students can focus on understanding concepts rather than manually sifting through extensive study materials.\n\n"
                        "Our mission is to enhance academic success by simplifying the learning process. By offering a smarter way to study, we empower students to stay organized, improve retention, and achieve their educational goals with greater ease.",
                        style: TextStyle(
                          fontSize: 16, // Enhanced readability
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center, // **Perfect Alignment**
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
