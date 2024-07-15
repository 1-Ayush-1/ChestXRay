import 'dart:io';

import 'package:check/nishkarsh/usermenu.dart';
// import 'package:cognix_chest_xray/Nishkarsh/usermenu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChooseImageScreen extends StatefulWidget {
  const ChooseImageScreen({super.key});
  @override
  State<ChooseImageScreen> createState() => _ChooseImageScreenState();
}

class _ChooseImageScreenState extends State<ChooseImageScreen> {
  XFile? _image;

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
      drawer: const MenuDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: _image != null
                  ? Image.file(File(_image!.path))
                  : const Center(child: Text('No image selected')),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, 'nish_route/');
                // final ImagePicker picker = ImagePicker();
                // final XFile? image =
                //     await picker.pickImage(source: ImageSource.camera);
                // setState(() {
                //   _image = image;
                // });
              },
              child: const Text('Capture from camera'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'image/');
              },
              child: const Text(
                'Upload from Gallery',
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Back',
              ),
            ),
            // GestureDetector(
            //   child: const Text("Back"),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // )
          ],
        ),
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
      ),
    );
  }
}