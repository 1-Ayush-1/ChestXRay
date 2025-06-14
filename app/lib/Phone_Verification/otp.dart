import 'package:check/Phone_Verification/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class MyOtp extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const MyOtp({super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<MyOtp> createState() => _MyOtpState();
}

class _MyOtpState extends State<MyOtp> {
  bool isLoading = false;
  String _verificationId = "";
  int? _resendToken;
  String mobilenum = "";

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    mobilenum = widget.phoneNumber;

  }

  Future<bool> resendOTP({required String phone}) async {
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
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(140, 196, 242, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(29, 232, 49, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(250, 248, 247, 1),
      ),
    );

    return Scaffold(
      
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        elevation: 4,
        backgroundColor: const Color.fromARGB(223, 24, 5, 235),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter Verification Code',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'We are automatically detecting an SMS\nsent to your mobile number ********234',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
                const SizedBox(height: 20.0),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                  onCompleted: (pin) async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: _verificationId,
                        smsCode: pin,
                      );

                      await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                        await Future.delayed(const Duration(seconds: 2)); // Introduce a delay
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  Verify(num: mobilenum,)));
                      });
                    } catch (ex) {
                      print(ex.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Authentication failed. Please try again.')),
                      );
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: isLoading ? null : () {
                    resendOTP(phone: widget.phoneNumber);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't receive OTP? ",
                      style: const TextStyle(color: Colors.black), // Non-clickable part
                      children: [
                        TextSpan(
                          text: 'Resend OTP',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (!isLoading) resendOTP(phone: widget.phoneNumber);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              
            ),
          ),
          if (isLoading)
            Center(
                child: CircularProgressIndicator(),
              ),
        ],
      ),
    );
  }
}
