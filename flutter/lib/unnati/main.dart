import 'package:flutter/material.dart';
// import 'api_service.dart';
// import 'user_profile.dart';
// import 'reports.dart';
// import 'ReportDetailPage.dart';
// import 'ReportDetailDocPage.dart';
// import 'reportlist.dart';
// import 'updateDoc.dart'; // Ensure this is imported correctly

class ShowReport extends StatefulWidget {
  const ShowReport({super.key});

  @override
  State<ShowReport> createState() => _ShowReportState();
}

class _ShowReportState extends State<ShowReport> {
  String token = "4d256ea6d224c62ed2cf021786193c16222b7c04"; 

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
              //  Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ReportDetailsPage(token: token)),
              //   );
              },
              child: const Text('Go to Report List'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => UpdateDoc()), // Navigate to UpdateDoc
            //     );
            //   },
            //   child: const Text('Go to Update Doc Page'),
            // ),
          ],
        ),
      ),
    );
  }
}
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Navigation Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String token = "4d256ea6d224c62ed2cf021786193c16222b7c04"; 

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ReportDetailsPage(token: token)),
//                 );
//               },
//               child: const Text('Go to Report List'),
//             ),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => UpdateDoc()), // Navigate to UpdateDoc
//             //     );
//             //   },
//             //   child: const Text('Go to Update Doc Page'),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
