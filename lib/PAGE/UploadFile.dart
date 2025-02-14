// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class UploadFile extends StatefulWidget {
//   const UploadFile({super.key});

//   @override
//   State<UploadFile> createState() => _UploadFileState();
// }

// class _UploadFileState extends State<UploadFile> {
//   double _progress = 0.0; // To track the upload progress
//   bool _isUploading = false;
//   double speedInMBps = 0.0;
//   Future<void> pickAndUploadPDF() async {
//     // Open file picker and allow user to select a PDF file
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['zip'],
//     );

//     if (result != null) {
//       String? filePath = result.files.single.path;

//       if (filePath != null) {
//         print('PDF file selected: $filePath');

//         // Call the upload function
//         await uploadPDF(filePath);
//       }
//     } else {
//       print('No file selected');
//     }
//   }

// // Upload file with progress tracking and speed calculation using Dio
//   Future<void> uploadPDF(String filePath) async {
//     Dio dio = Dio();

//     // Prepare the file
//     File file = File(filePath);
//     String fileName = file.path.split('/').last;
//     var url = dotenv.env['URL']! + "upload";

//     // Create a FormData object to send the file
//     FormData formData = FormData.fromMap({
//       'file': await MultipartFile.fromFile(file.path, filename: fileName),
//     });

//     setState(() {
//       _isUploading = true;
//       _progress = 0.0;
//       speedInMBps = 0.0;
//     });

//     int lastTime = DateTime.now().millisecondsSinceEpoch;
//     int totalBytesSend = 0;

//     try {
//       await dio.post(
//         url, // Replace with your server URL
//         data: formData,
//         onSendProgress: (sent, total) {
//           if (total != -1) {
//             setState(() {
//               _progress = sent / total; // Calculate the upload progress
//             });

//             // Calculate transfer speed
//             int currentTime = DateTime.now().millisecondsSinceEpoch;
//             int bytesTransferred = sent - totalBytesSend;
//             int timeTaken = currentTime - lastTime;

//             if (timeTaken > 0) {
//               double speed = bytesTransferred /
//                   (timeTaken / 1000.0); // speed in bytes per second
//               speedInMBps = speed / (1024 * 1024); // speed in KBps
//               print('Speed: ${speedInMBps.toStringAsFixed(2)} MB/s');
//             }
//           }
//         },
//       );

//       setState(() {
//         _isUploading = false;
//       });
//       print('File uploaded successfully');
//     } catch (e) {
//       setState(() {
//         _isUploading = false;
//       });
//       print('Error uploading file: $e');
//     } finally {
//       dio.close();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(225, 7, 7, 27),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Progress bar
//             _isUploading
//                 ? Column(
//                     children: [
//                       LinearProgressIndicator(value: _progress),
//                       SizedBox(height: 20),
//                       Text(
//                         'Uploading... ${(_progress * 100).toStringAsFixed(0)}% \n Speed ${speedInMBps.toStringAsFixed(2)} MB/s ',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ],
//                   )
//                 : ElevatedButton.icon(
//                     icon: Icon(
//                       Icons.upload,
//                       color: Colors.white,
//                       // size: 30.0,
//                     ),
//                     label: Text(
//                       'Upload PDF',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () {
//                       pickAndUploadPDF();
//                     },
//                     style: ButtonStyle(
//                         //color of button
//                         backgroundColor: WidgetStateProperty.all<Color>(
//                             Color.alphaBlend(
//                                 Colors.deepPurpleAccent, Colors.indigo)),
//                         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           //side: BorderSide(color: Colors.red)
//                         ))))
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  double _progress = 0.0; // To track the upload progress
  bool _isUploading = false;
  bool _isFilePicking = false; // New state to track if file is being picked
  double speedInMBps = 0.0;

  Future<void> pickAndUploadPDF() async {
    // Show loader while the file is being picked
    setState(() {
      _isFilePicking = true;
    });

    // Open file picker and allow user to select a PDF file
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    // Hide the loader once the file picker is done
    setState(() {
      _isFilePicking = false;
    });

    if (result != null) {
      String? filePath = result.files.single.path;

      if (filePath != null) {
        print('PDF file selected: $filePath');

        // Call the upload function
        await uploadPDF(filePath);
      }
    } else {
      print('No file selected');
    }
  }

  // Upload file with progress tracking and speed calculation using Dio
  Future<void> uploadPDF(String filePath) async {
    Dio dio = Dio();

    // Prepare the file
    File file = File(filePath);
    String fileName = file.path.split('/').last;
    var url = dotenv.env['URL']! + "UploadPdf";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Create a FormData object to send the file
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      'token': prefs.getString("token")
    });

    setState(() {
      _isUploading = true;
      _progress = 0.0;
      speedInMBps = 0.0;
    });

    int lastTime = DateTime.now().millisecondsSinceEpoch;
    int totalBytesSend = 0;

    try {
      await dio.post(
        url, // Replace with your server URL
        data: formData,
        onSendProgress: (sent, total) {
          if (total != -1) {
            setState(() {
              _progress = sent / total; // Calculate the upload progress
            });

            // Calculate transfer speed
            int currentTime = DateTime.now().millisecondsSinceEpoch;
            int bytesTransferred = sent - totalBytesSend;
            int timeTaken = currentTime - lastTime;

            if (timeTaken > 0) {
              double speed = bytesTransferred /
                  (timeTaken / 1000.0); // speed in bytes per second
              speedInMBps = speed / (1024 * 1024); // speed in KBps
              print('Speed: ${speedInMBps.toStringAsFixed(2)} MB/s');
            }
          }
        },
      );

      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('File uploaded successfully'),
        backgroundColor: Colors.green,
      ));
      print('File uploaded successfully');
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error while uploading file,Try again'),
        backgroundColor: Colors.red,
      ));
      print('Error uploading file: $e');
    } finally {
      dio.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(225, 7, 7, 27),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show loader if file is being picked
            if (_isFilePicking)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            // Progress bar if file is uploading
            if (_isUploading)
              Column(
                children: [
                  LinearProgressIndicator(value: _progress),
                  SizedBox(height: 20),
                  Text(
                    'Uploading... ${(_progress * 100).toStringAsFixed(0)}% \n Speed ${speedInMBps.toStringAsFixed(2)} MB/s ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            // Button to trigger file picker
            if (!_isUploading && !_isFilePicking)
              ElevatedButton.icon(
                icon: Icon(
                  Icons.upload,
                  color: Colors.white,
                  // size: 30.0,
                ),
                label: Text(
                  'Upload PDF',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  pickAndUploadPDF();
                },
                style: ButtonStyle(
                    //color of button
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurpleAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
              ),
          ],
        ),
      ),
    );
  }
}
