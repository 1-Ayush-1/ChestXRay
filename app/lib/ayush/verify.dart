import 'dart:convert';
import 'package:check/saumya/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

//Here write for Doctor Profile
////////////////////////////
Future<void> saveUserDetailsDoc(BuildContext context, String finalnumber, String random) async {
  String ournum = finalnumber.substring(3);
  final response = await http.patch(
    Uri.parse('http://51.20.3.117/api/users/doctor_profile/'),
    headers: {
      'Content-Type': 'application/json',
        // 'Accept': 'application/x-www-form-urlencoded',
      'Authorization': 'Token $random'
    },
    body: jsonEncode({'mobile_num': ournum}),
  );
  print(ournum);
  print(random);
  print(response.body);
  if (response.statusCode == 200) {
    // print('badiya hai');
    print('Details saved');
    Navigator.pushNamed(context, 'post_doctor/');
  } 
  else if (response.statusCode == 400) {
    // Show a snackbar with the message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User with this mobile number already exists. Please verify with another number.'),
      ),
    ).closed.then((reason) {
      // After Snackbar is closed, navigate to 'Postpatient_Container/'
      Navigator.pushNamed(context, 'patient_profile/');
    });
  } else {
    // Handle other status codes or throw an exception as needed
    print(response.statusCode);
    print('Failed to save user details: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to save user details: ${response.statusCode}');
  }
  // Navigator.pushNamed(context, 'patient_profile/');
}




//This is for patient Profile
///////////////////////////
Future<void> saveUserDetails(
    BuildContext context, String finalnumber, String random) async {
  String ournum = finalnumber.substring(3);
  final response = await http.patch(
    Uri.parse('http://51.20.3.117/api/users/patient_profile/'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token $random'
    },
    body: jsonEncode({'mobile_num': ournum}),
  );
  
  print(ournum);
  print(random);
  
  if (response.statusCode == 200) {
    print('Details saved');
     Navigator.pushNamed(context, 'patient_profile/');
  } else if (response.statusCode == 400) {
    // Show a snackbar with the message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User with this mobile number already exists. Please verify with another number.'),
      ),
    ).closed.then((reason) {
      // After Snackbar is closed, navigate to 'Postpatient_Container/'
      Navigator.pushNamed(context, 'patient_profile/');
    });
  } else {
    // Handle other status codes or throw an exception as needed
    print(response.statusCode);
    print('Failed to save user details: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to save user details: ${response.statusCode}');
  }
  // Navigator.pushNamed(context, 'patient_profile/');
}

////////////////////////////

class Verify extends StatefulWidget {
  final num;
  const Verify({super.key, this.num});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Accessing user data from UserProvider
    final user = userProvider.user;
    print(user!.token);
    print(user.username);
    // print(widget.num);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 46, 0, 251),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Successfully',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your mobile number has been registered.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if(user.occupation != 'Doc') saveUserDetails(context, widget.num, user.token);
                  else saveUserDetailsDoc(context, widget.num, user.token);
                  // Handle button press
                },
                child: Text('Continue'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 16,
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
