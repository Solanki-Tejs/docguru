import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "CONTACT US",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "We would love to hear from you! Whether you have questions, feedback, or need support, feel free to reach out to us.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),

              _buildRoundedTextField(context, "Email", "docguru.mail@gmail.com",
                  Icons.email_outlined),
              SizedBox(height: 20),


              _buildRoundedTextField(
                  context, "GitHub", "github.com/Docguru", Icons.code),
              SizedBox(height: 20),

              _buildRoundedTextField(context, "X (Twitter)",
                  "twitter.com/DocguruMail", Icons.alternate_email),
              SizedBox(height: 20),

              _buildRoundedTextField(context, "Support Hours",
                  "Mon - Fri, 9 AM - 6 PM", Icons.access_time),
              SizedBox(height: 40),
              // Support Message (Larger & Centered)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "If you're experiencing issues with the app, please include a detailed description of the problem along with your device information, and we'll get back to you as soon as possible.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Text Field with Icon + Copy Button Inside the Box
  Widget _buildRoundedTextField(
      BuildContext context, String label, String text, IconData icon) {
    return TextField(
      readOnly: true,
      style: TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white, fontSize: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.black,
        contentPadding: EdgeInsets.symmetric(vertical: 22, horizontal: 25),

        // ✅ Icon in Front of the Text Field
        prefixIcon: Icon(icon, color: Colors.white, size: 26),

        // ✅ Copy Button Inside the Box (Trailing Icon)
        suffixIcon: IconButton(
          icon: Icon(Icons.copy, color: Colors.white, size: 26), // Copy icon
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("$label copied!", style: TextStyle(fontSize: 16)),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
      controller: TextEditingController(text: text),
    );
  }
}
