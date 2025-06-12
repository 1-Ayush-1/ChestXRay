import 'package:check/Sourish/Screens/doctor_detail_screen.dart';
import 'package:check/Sourish/Screens/doctor_model.dart';
import 'package:check/Sourish/Screens/doctor_search_screen.dart';
import 'package:check/riya/postdoctor.dart';
// import 'package:check/riya/message_container.dart';
import 'package:check/riya/postmessage.dart';
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
import 'package:check/tanish/patient_search.dart';
import 'package:check/unnati/ReportDetailDocPage.dart';
// import 'package:check/tanish/patient_search.dart';
import 'package:check/unnati/main.dart';
import 'package:check/vaibhav/chat.dart';
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
    final userProvider = Provider.of<UserProvider>(context);
    
    // Accessing user data from UserProvider
    final user = userProvider.user;
    

    return MaterialApp(
          // Accessing UserProvider instance
      
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
          // 'give_review/': (context) => MessageContainer(doctorId: '', doctorName: '', doctorImageUrl: '', Token: user!.token,),//riya 
          'patient_profile/': (context) => Postpatient_Container(staticId: user!.staticId,  Token: user.token),//riya
          'post_doctor/' : (context) => Postdoctor_Container(staticId:user!.staticId , Token: user.token,),//riya
          'doctor_detail/': (context) => DoctorDetailScreen(doctor: ModalRoute.of(context)!.settings.arguments as Doctor),
          'doctor_search/': (context) => SearchScreen(),
          'chat_message/': (context) =>  ChatScreen(), //Vaibhav
          'patient_search_screen/': (context) => PatientSearchScreen(token: '${user!.token}',),
          // 'report_detail_doc/': (context) =>  ReportDetailDocPage(reportStaticId: '', token: user!.token,),
          // 'profile_search/' : (context) =>  SearchScreen(), //sourish
      }
      
    );
  }
}
