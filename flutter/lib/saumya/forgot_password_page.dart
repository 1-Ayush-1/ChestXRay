import 'dart:convert';
import 'package:check/saumya/reset_password_page.dart';
// import 'package:example_app/reset_password_page.dart';
// import 'package:example_app/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:check_firebase-20240708T064624Z-001/save_data.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({super.key});
  
  
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  
// late UserModel _user;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUser();
//   }

//   Future<void> _fetchUser() async {
//     try {
//       UserService userService = UserService();
//       UserModel? user = await userService.getUser();

//       if (user != null) {
//         setState(() {
//           _user = user;
//         });
//       } else {
//         // Handle case where no user is logged in
//         print('No user logged in');
//       }
//     } catch (e) {
//       // Handle error fetching user data
//       print('Error fetching user: $e');
//     }
//   }

  Future<void> recover() async {
    
    String url = 'http://51.20.3.117/auth/send-otp/'; // Replace with your backend URL

    try {
      final response = await http.post(
        Uri.parse(url),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': _emailController.text.trim(),
        }),
        
      );
      print('Sending POST request to: $url'); // Debug statement
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
      
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String? token = responseData['token'];
        // Handle storing the token or user data as needed
        // Navigate to next screen upon successful login
        // print('mobile_num : ${_user.mobileNum}');
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(email: _emailController.text.trim()),
        ),
      ); // Replace with your dummy screen route
        print('otp sent. Token: $token');
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        // Unauthorized - Incorrect credentials
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Invalid email"),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Handle other status codes
        print('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error during reset: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Failed to connect to the server. Please check your connection."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Forgot Your\nPassword?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Worries! Type in your email ID and we’ll send you a link to recover your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle password recovery logic
                    String email = _emailController.text;
                    recover();
                    print('Recover password for: $email');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Recover Password'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Back To '),
                    TextButton(
                      onPressed: () {
                        // Navigate back to the login page
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}