import 'package:check/Profile_Info/Screens/doctor_detail_screen.dart';
import 'package:check/Profile_Info/Screens/doctor_model.dart';
import 'package:check/Profile_Info/Screens/doctor_search_screen.dart';
import 'package:check/Doctor_Patient_Detail/postdoctor.dart';
// import 'package:check/riya/message_container.dart';
import 'package:check/Doctor_Patient_Detail/postmessage.dart';
import 'package:check/Doctor_Patient_Detail/postpatient.dart';
import 'package:check/User_Verification/dummy.dart';
import 'package:check/Phone_Verification/image.dart';
import 'package:check/Upload_Image/chooseimage.dart';
import 'package:check/Upload_Image/uploadprompt.dart';
import 'package:check/Upload_Image/upload_screen.dart';
import 'package:check/Phone_Verification/otp.dart';
import 'package:check/Phone_Verification/test.dart';
import 'package:check/Phone_Verification/phone.dart';
import 'package:check/Phone_Verification/verify.dart';
import 'package:check/Patient_Search/patient_search.dart';
import 'package:check/Report_Details/ReportDetailDocPage.dart';
// import 'package:check/tanish/patient_search.dart';
import 'package:check/Report_Details/main.dart';
import 'package:check/App_Chat/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'User_Verification/login_page.dart';
import 'User_Verification/forgot_password_page.dart';
import 'Patient_Search/signup.dart';
import 'User_Verification/reset_password_page.dart';
import 'User_Verification/user_provider.dart';

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
