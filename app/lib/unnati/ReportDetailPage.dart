import 'package:check/saumya/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'image_model.dart';
import 'update_doc.dart'; // Import the UpdateDoc screen

class ReportDetailPage extends StatefulWidget {
  final String? reportStaticId;
  final String token;

  const ReportDetailPage(
      {Key? key, required this.reportStaticId, required this.token})
      : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  late Future<Map<String, dynamic>> _futureUserData;
  late Future<ImageData> _futureReportData;

  bool isLoading = true;
  void debug() {
    print("ok");
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      _futureUserData = ApiService().fetchUserData(widget.token);
      _futureReportData = ApiService().fetchReportData(widget.reportStaticId!);

      await Future.wait([_futureUserData, _futureReportData]);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final userProvider = Provider.of<UserProvider>(context);
    // Accessing user data from UserProvider
    final user = userProvider.user;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>>(
              future: _futureUserData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return FutureBuilder<ImageData>(
                    future: _futureReportData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final reportData = snapshot.data!;
                        return Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User Info

                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 40, horizontal: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Color(0xff4268b0)),
                                width: 440,
                                height: 125,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          user!.profilePhoto!.isNotEmpty
                                              ? NetworkImage(user.profilePhoto!)
                                              : const AssetImage(
                                                      'assets/screen.png')
                                                  as ImageProvider,
                                    ),
                                    // const SizedBox(width: 16.0),
                                    SizedBox(width: 30),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hello, ${user.name}!',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.03),
                              // Report Data
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  reportData.originalImage != null
                                      ? Image.network(
                                          reportData.originalImage!,
                                          width: screenWidth * 0.4,
                                          height: screenHeight * 0.2,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Image.asset(
                                                'assets/screen.png',
                                                width: screenWidth * 0.4,
                                                height: screenHeight * 0.2);
                                          },
                                        )
                                      : Image.asset('assets/screen.png',
                                          width: screenWidth * 0.4,
                                          height: screenHeight * 0.2),
                                  SizedBox(width: screenWidth * 0.05),
                                  Text('Your Image',
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.04)),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              // AI Image and AI Text row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  reportData.aiImage != null
                                      ? Image.network(
                                          reportData.aiImage!,
                                          width: screenWidth * 0.4,
                                          height: screenHeight * 0.2,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Image.asset(
                                                'assets/screen.png',
                                                width: screenWidth * 0.4,
                                                height: screenHeight * 0.2);
                                          },
                                        )
                                      : Image.asset('assets/doctor.jpeg',
                                          width: screenWidth * 0.4,
                                          height: screenHeight * 0.2),
                                  SizedBox(width: screenWidth * 0.05),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      reportData.aiImage != null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('AI Image',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                SizedBox(height: 10),
                                                Text(reportData.aiText ??
                                                    ''), // Show AI text if available, otherwise show an empty string
                                              ],
                                            )
                                          : const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('AI Image',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                SizedBox(height: 10),
                                                Text(
                                                    ""), // Empty text widget if AI image is null
                                              ],
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              // Consult doctor button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateDoc(reportId: reportData.staticId, token: user.token,),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff4268b0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.02),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02),
                                    child: Text(
                                      'Consult doctor',
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(child: Text('No report available'));
                      }
                    },
                  );
                } else {
                  return const Center(child: Text('No user data available'));
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
