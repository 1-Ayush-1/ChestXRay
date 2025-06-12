
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:check/saumya/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';



Future<UploadResponse> uploadImage(File image, String random, String Static_id) async {

  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://51.20.3.117/api/images/upload_scan/'), // For Android Emulator
    );
    String patientStaticId = '$Static_id';
    //token : 7203e82f5db71e8baf6fddf08c80a24eb00be56d
    print(random);
    print(Static_id);
    request.fields['patient_static_id'] = patientStaticId; // Add patient_static_id
    
    String fileName = image.path.split('/').last; // Get file name with extension
    
    request.headers['Authorization'] = 'Token $random';
    
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

class Uploader extends StatefulWidget {
  const Uploader({super.key});

  @override
  State<Uploader> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  File? _image;
  Future<UploadResponse>? _futureResponse;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // Accessing user data from UserProvider
    final user = userProvider.user;
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
                        _futureResponse = uploadImage(_image!,user!.token,user.staticId);
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, 'patient_menu/');
          }
          // Handle other items as needed
        },
        currentIndex: 0, // Set the initial selected index
        selectedItemColor: Colors.blue, // Change the selected item color
      ),
    );
  }

  FutureBuilder<UploadResponse> buildFutureBuilder() {
  return FutureBuilder<UploadResponse>(
    future: _futureResponse,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasData) {
        // Navigate after showing the success message
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Navigator.pushNamed(context, 'patient_menu/');
        });
        return Text(snapshot.data!.message ?? 'Your image has been added successfully');
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      return CircularProgressIndicator(); // Handle other states if necessary
    },
  );
}

}

