import 'package:check/riya/postpatient.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:myapp/postpatient.dart';

// class RiyaMain extends StatefulWidget {
//   const RiyaMain({super.key});

//   @override
//   State<RiyaMain> createState() => _RiyaMainState();
// }

// class _RiyaMainState extends State<RiyaMain> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color(0xff4268b0),
//           elevation: 2,
//         ),
//         bottomNavigationBar: GNav(
//           activeColor: Color(0xff4268b0),
//           tabs: const [
//             GButton(icon: Icons.home),
//             GButton(icon: Icons.settings),
//             GButton(icon: Icons.logout),
//           ],
//         ),
//         // bottomNavigationBar: BottomNavigationBar(
//         //   backgroundColor: Color(0xff4268b0),
//         //   items: [
//         //     BottomNavigationBarItem(icon: Icon(Icons.home)),
//         //     BottomNavigationBarItem(icon: Icon(Icons.settings)),
//         //     BottomNavigationBarItem(icon: Icon(Icons.logout)),
//         //   ],
//         // ),

//         backgroundColor: Colors.white,
//         body: Postpatient_Container(
//             staticId: 'b2e48483-f91e-4e8c-bec2-e833b204f32a',
//             token: '0399e7febfd5bbf32b51272d30a902592f766ec8'),
//       );
//   }
// }

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff4268b0),
          elevation: 2,
        ),
        bottomNavigationBar: GNav(
          activeColor: Color(0xff4268b0),
          tabs: const [
            GButton(icon: Icons.home),
            GButton(icon: Icons.settings),
            GButton(icon: Icons.logout),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Color(0xff4268b0),
        //   items: [
        //     BottomNavigationBarItem(icon: Icon(Icons.home)),
        //     BottomNavigationBarItem(icon: Icon(Icons.settings)),
        //     BottomNavigationBarItem(icon: Icon(Icons.logout)),
        //   ],
        // ),

        backgroundColor: Colors.white,
        body: Postpatient_Container(
            staticId: 'b2e48483-f91e-4e8c-bec2-e833b204f32a',
            token: '0399e7febfd5bbf32b51272d30a902592f766ec8'),
      ),
    ),
  );
}
