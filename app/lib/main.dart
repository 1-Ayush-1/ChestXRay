import 'package:check/Sourish/Screens/doctor_detail_screen.dart';
import 'package:check/Sourish/Screens/doctor_model.dart';
import 'package:check/Sourish/Screens/doctor_search_screen.dart';
import 'package:check/riya/message_container.dart';
import 'package:check/riya/postpatient.dart';
import 'package:check/saumya/dummy.dart';
import 'package:check/ayush/image.dart';
import 'package:check/nishkarsh/chooseimage.dart';
import 'package:check/nishkarsh/uploadprompt.dart';
import 'package:check/nishkarsh/upload_screen.dart';
import 'package:check/ayush/otp.dart';
import 'package:check/ayush/test.dart';
import 'package:check/ayush/phone.dart';
import 'package:check/ayush/verify.dart';
import 'package:check/unnati/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saumya/login_page.dart';
import 'saumya/forgot_password_page.dart';
import 'tanish/signup.dart';
import 'saumya/reset_password_page.dart';
import 'saumya/user_provider.dart';

 // Replace with your UserProvider file
// import 'unnati/main.dart';

const primary = Color(0xff4268b0);
const background = Color(0xffcde2f5);
// import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(), // Initialize UserProvider
      child: MyApp(),
    ),


  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OTP Verification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'login/',
      routes: {
          'otp/':(context) =>  MyOtp(verificationId: 'verificationId', phoneNumber: 'phone',),
          'verify/':(context) => const Verify(),
          'image/' : (context) => const Uploader(),
          'test/' : (context) => const Mytest(),
          'phone/' : (context) => PhoneNumberPage(),
          'forgot-password/': (context) => ForgotPasswordPage(),
          'login/' : (context) => const LoginPage(),
          'dummy-screen/' : (context) => const MyDummy(),
          'reset-pswd/' : (context) => ResetPasswordPage(email: 'email',), 
          'signup/': (context) => SignUpScreen(),
          'patient_menu/': (context) => const UploadPromptScreen(), //home screen ->nishkarsh
          'upload_pic/': (context) => const ChooseImageScreen(),
          'showreport/': (context) => const ShowReport(),
          'nish_route/': (context) => const Uploader_nish(), //nishkarsh
          'give_review/': (context) => const MessageContainer(),
          'patient_profile/': (context) => Postpatient_Container(staticId: 'b2e48483-f91e-4e8c-bec2-e833b204f32a', token: '0399e7febfd5bbf32b51272d30a902592f766ec8'),
          'doctor_detail/': (context) => DoctorDetailScreen(doctor: ModalRoute.of(context)!.settings.arguments as Doctor),
          'doctor_search/': (context) => SearchScreen(),

      }
    );
  }
}
