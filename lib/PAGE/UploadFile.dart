import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:docguru/PAGE/Home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UploadFile extends StatefulWidget {
  final Function toggleUploadStatus;
  final int pageIndex;
  final Function(String, String) onNameChange;

  const UploadFile(
      {super.key,
      required this.toggleUploadStatus,
      required this.pageIndex,
      required this.onNameChange});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  double _progress = 0.0; // To track the upload progress
  bool _isUploading = false;
  bool _isFilePicking = false; // New state to track if file is being picked
  double speedInMBps = 0.0;
  late String fileName = "hello";

  final loader = SpinKitCubeGrid(color: Colors.white);

  final loader1 = SpinKitThreeBounce(
    color: Colors.purple,
    // size: 200,
    // duration: Duration(seconds: 2),
  );

  Future<void> onPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("onPage", widget.pageIndex);
  }

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
    fileName = file.path.split('/').last;
    var url = dotenv.env['URL']! + "UploadPdf";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
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

      var res = await dio.post(
        url,
        data: formData,
        onSendProgress: (sent, total) {
          if (total != -1) {
            setState(() {
              _progress = sent / total;
            });

            // Calculate transfer speed
            int currentTime = DateTime.now().millisecondsSinceEpoch;
            int bytesTransferred = sent - totalBytesSend;
            int timeTaken = currentTime - lastTime;

            if (timeTaken > 0) {
              double speed = bytesTransferred / (timeTaken / 1000.0);
              speedInMBps = speed / (1024 * 1024);
              print('Speed: ${speedInMBps.toStringAsFixed(2)} MB/s');
            }
            print("progress: ${_progress}");
          }
        },
      );

      print("uploading will be set false");

      setState(() {
        _isUploading = false;
      });
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('File uploaded successfully'),
          backgroundColor: Colors.green,
        ));
        var data = res.data;
        print(data);
        var collactionFileName = data['collactionName'];
        print(collactionFileName);
        widget.onNameChange(fileName, collactionFileName); // Set the page name
        widget.toggleUploadStatus();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }

      print('File uploaded successfully');
      // } catch (e) {
      //   setState(() {
      //     _isUploading = false;
      //   });
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Error while uploading file,Try again'),
      //     backgroundColor: Colors.red,
      //   ));
      //   print('Error uploading file: $e');
      // }
    } finally {
      dio.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    onPage();
    return Scaffold(
      backgroundColor: Color.fromARGB(225, 7, 7, 27),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // loader,
            // loader1,
            if (_isFilePicking)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),

            if (_isUploading)
              (_progress == 1.0)
                  ? Column(
                      children: [
                        loader,
                        SizedBox(height: 20),
                        Text(
                          'Vectorizing your pdf.',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          'This may take a few mintes ... ',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 80),
                          child: LinearProgressIndicator(value: _progress),
                        ),
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
