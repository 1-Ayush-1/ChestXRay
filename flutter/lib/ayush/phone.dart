import 'package:flutter/material.dart';
import 'package:check/ayush/otp.dart'; // Adjust import as per your project structure
import 'package:firebase_auth/firebase_auth.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  String _verificationId = "";
  int? _resendToken;

  Future<bool> sendOTP({required String phone}) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed. Please try again.')),
          );
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyOtp(verificationId: verificationId, phoneNumber: phone)),
          );
        },
        timeout: const Duration(seconds: 25),
        forceResendingToken: _resendToken,
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
      debugPrint("_verificationId: $_verificationId");
      return true;
    } catch (e) {
      debugPrint("Failed to send OTP: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Number Verification'),
        foregroundColor: Color.fromARGB(223, 255, 255, 255),
        backgroundColor: Color.fromARGB(223, 24, 5, 235), // Custom app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.phone_android), // Icon for phone OTP
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String phoneNumber = _phoneNumberController.text.trim();
                if (phoneNumber.isNotEmpty) {
                  sendOTP(phone: phoneNumber);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid phone number.')),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                child: Text(
                  'Verify',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(223, 24, 5, 235), // Custom button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
