import 'package:check/main.dart';
import 'package:check/Upload_Image/profileheader.dart';
import 'package:check/Upload_Image/usermenu.dart';
import 'package:check/User_Verification/user_provider.dart';
import 'package:check/Report_Details/reportlist.dart';
// import 'package:cognix_chest_xray/Nishkarsh/profileheader.dart';
// import 'package:cognix_chest_xray/Nishkarsh/usermenu.dart';
// import 'package:cognix_chest_xray/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:provider/provider.dart';

class UploadPromptScreen extends StatelessWidget {
  const UploadPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InstructionText(),
              UploadButtons(),
              // UploadInstructions(),
            ],
          )
        ],/////////////////////////////////////////////////////////////////////
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: primary,
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

class InstructionText extends StatelessWidget {
  const InstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    
    //////////////////////////////////////////////////
    final userProvider = Provider.of<UserProvider>(context);
    
    // Accessing user data from UserProvider
    final user = userProvider.user;
    print('abcsadfa');
    print('${user!.mobileNumber}'); 
    print('afavsv');
    /////////////////////////////////////////////////////
    return Container(
      
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Welcome to our Chest X-Ray App! You can upload your chest X Ray images and get both AI guidance as well as consult a doctor.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class UploadButtons extends StatelessWidget {
  const UploadButtons({super.key});

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////
    
    final userProvider = Provider.of<UserProvider>(context);
    
    // Accessing user data from UserProvider
    final user = userProvider.user;


    ///////////////////////////////////
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'upload_pic/');
          },
          child: Column(
            children: [
              const Icon(
                Icons.camera_alt,
                size: 96,
                color: primary,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'upload_pic/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Upload Pic'),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              const Icon(
                Icons.assignment,
                size: 96,
                color: primary,
              ),
              // Text('Mobile Number: ${user!.email}'),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportDetailsPage(token: "${user!.token}"))
                );
                },
                
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('View Report'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UploadInstructions extends StatelessWidget {
  const UploadInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        children: [
          Text(
            'Instructions to upload image',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('- Instruction1'),
          Text('- Instruction2'),
          Text('- Instruction3'),
        ],
      ),
    );
  }
}