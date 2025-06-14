import 'package:check/main.dart';
import 'package:check/Upload_Image/profileheader.dart';
import 'package:check/Upload_Image/usermenu.dart';
import 'package:check/User_Verification/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'user_profile.dart';
import 'reports.dart';
import 'ReportDetailPage.dart';
import 'ReportDetailDocPage.dart';

class ReportDetailsPage extends StatefulWidget {
  final String token;

  const ReportDetailsPage({super.key, required this.token});

  @override
  _ReportDetailsPageState createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  late Future<UserProfile> _futureUserProfile;
  late Future<List<UserReport>> _futureUserReports;

  @override
  void initState() {
    super.initState();
    _futureUserProfile = ApiService().fetchUserProfile(widget.token);
    _futureUserReports = ApiService().fetchUserReports(widget.token);
  }

  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Accessing user data from UserProvider
    final user = userProvider.user;
    return Scaffold(
      drawer: MenuDrawer(),
      body: FutureBuilder<UserProfile>(
        future: _futureUserProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileHeader(),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       vertical: 40, horizontal: 16),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(40),
                  //       color: Color(0xff4268b0)),
                  //   width: 310,
                  //   height: 125,
                  //   child: Row(
                  //     children: [
                  //       CircleAvatar(
                  //         radius: 40,
                  //         backgroundImage:
                  //             snapshot.data!.profilePhoto!.isNotEmpty
                  //                 ? NetworkImage(snapshot.data!.profilePhoto!)
                  //                 : const AssetImage('assets/screen.png')
                  //                     as ImageProvider,
                  //       ),
                  //       // const SizedBox(width: 16.0),
                  //       SizedBox(width: 30),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             'Hello, ${snapshot.data!.name}!',
                  //             style: const TextStyle(
                  //               fontSize: 24,
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 16.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Please find your previous reports here -',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  FutureBuilder<List<UserReport>>(
                      future: _futureUserReports,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child:
                                Text('Error fetching data: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          final reports = snapshot.data!;

                          if (reports.isEmpty) {
                            return const Center(
                              child: Text('No reports available'),
                            );
                          }

                          return ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            shrinkWrap:
                                true, // Important for scrollable inside SingleChildScrollView
                            physics:
                                NeverScrollableScrollPhysics(), // Disable inner ListView scrolling
                            itemCount: reports.length,
                            itemBuilder: (context, index) {
                              final report = reports[index];
                              return GestureDetector(
                                onTap: report.aiImage != null
                                    ? () {
                                        if (report.doctorComments ==
                                            "No Comments") {
                                          //sourish
                                          // Navigator.pushNamed(context, 'doctor_search/');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportDetailPage(
                                                token: widget.token,
                                                reportStaticId: report.staticId,
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportDetailDocPage(
                                                token: widget.token,
                                                reportStaticId: report.staticId!,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    : () {
                                        if (report.doctorComments ==
                                            "No Comments") {
                                          //sourish
                                          // Navigator.pushNamed(context, 'doctor_search/');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportDetailPage(
                                                token: widget.token,
                                                reportStaticId: report.staticId,
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportDetailDocPage(
                                                token: widget.token,
                                                reportStaticId: report.staticId!,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                            report.aiImage ??
                                                report.originalImage!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                  'assets/screen.png',
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          child: Text(
                                            report.aiImage != null
                                                ? (report.aiText!
                                                    // ElevatedButton(onPressed: onPressed, child: child)
                                                    )
                                                : 'not processed',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text('No reports available'),
                          );
                        }
                      }),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Unexpected error'),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, 'patient_menu/');
          }
          // Handle other items as needed
        },
        currentIndex: 0, // Set the initial selected index
        selectedItemColor: Colors.blue, // Change the selected item color
      ),
    );
  }
}
