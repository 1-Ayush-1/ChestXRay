import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

Future<UploadResponse> uploadImage(File image) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://51.20.3.117/images/upload_scan/'), // For Android Emulator
    );
    String patientStaticId = '2e974717-aeb4-4f3c-9b65-1a08b45c3842';
    //token : 7203e82f5db71e8baf6fddf08c80a24eb00be56d
    
    request.fields['patient_static_id'] = patientStaticId; // Add patient_static_id
    
    String fileName = image.path.split('/').last; // Get file name with extension
    
    request.headers['Authorization'] = 'Token 7203e82f5db71e8baf6fddf08c80a24eb00be56d';
    
    request.files.add(
      await http.MultipartFile.fromPath(
        'original_image',
        image.path,
        filename: fileName, // Set the original file name with extension
      ),

    );

    var response = await request.send();

    if (response.statusCode == 201) {
      final responseData = await response.stream.bytesToString();
      return UploadResponse.fromJson(jsonDecode(responseData));
    } else {
      print('Server responded with status code: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
      throw Exception('Failed to upload image: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
    rethrow; // Rethrow the exception to propagate it up
  }
}

class UploadResponse {
  final String? message;

  UploadResponse({required this.message});

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      message: json['message'] as String?,
    );
  }
}
class Uploader_nish extends StatefulWidget {
  const Uploader_nish({super.key});

  @override
  State<Uploader_nish> createState() => _Uploader_nishState();
}

class _Uploader_nishState extends State<Uploader_nish> {
  File? _image;
  // XFile? 
  Future<UploadResponse>? _futureResponse;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        _image = image as File?;
                      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker'),
        centerTitle: true,
        elevation: 4,
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Color.fromARGB(223, 24, 5, 235),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_image != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 4, // You can change the border width as needed
                    ),
                  ),
                  child: Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 6, // You can change the border width as needed
                    ),
                  ),
                  child: Image.asset(
                    'assets/sample1.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ],
            ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image == null)
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Select'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    backgroundColor: Color.fromARGB(223, 24, 5, 235),
                    foregroundColor: Color.fromARGB(223, 255, 255, 255),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    if (_image != null) {
                      setState(() {
                        _futureResponse = uploadImage(_image!);
                      });
                    }
                  },
                  child: Text('Upload'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    backgroundColor: Color.fromARGB(223, 24, 5, 235),
                    foregroundColor: Color.fromARGB(223, 255, 255, 255),
                  ),
                )
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _image = null;
              Navigator.pop(context);
              // Handle back button press
            },
            child: Text('Back'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              backgroundColor: Color.fromARGB(223, 24, 5, 235),
              foregroundColor: Color.fromARGB(223, 255, 255, 255),
            ),
          ),
          SizedBox(height: 10),
          _futureResponse == null ? Container() : buildFutureBuilder(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
      ),
    );
  }

  FutureBuilder<UploadResponse> buildFutureBuilder() {
    return FutureBuilder<UploadResponse>(
      future: _futureResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.message ?? 'Your image has been added Sucessfully');
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
      
        return const CircularProgressIndicator();
      },
    );
  }
}

