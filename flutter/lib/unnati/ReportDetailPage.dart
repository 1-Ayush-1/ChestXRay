import 'package:flutter/material.dart';
import 'api_service.dart';
import 'image_model.dart';

class ReportDetailPage extends StatefulWidget {
  final String? reportStaticId;
  final String token;

  const ReportDetailPage({Key? key, required this.reportStaticId, required this.token}) : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  late Future<Map<String, dynamic>> _futureUserData;
  late Future<ImageData> _futureReportData;
  bool isLoading = true;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Detail'),
        backgroundColor: Colors.blue,
      ),
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
                  final userData = snapshot.data!;
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
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User Info
                              Container(
                                color: Colors.lightBlue,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.01,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: screenWidth * 0.08,
                                      backgroundImage: userData['profile_pic'] != null
                                          ? NetworkImage(userData['profile_pic'])
                                          : const AssetImage('assets/screen.png') as ImageProvider,
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Hello, ${userData['name']}!',
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.05,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: screenHeight * 0.005),
                                          Text(
                                            '@${userData['static_id']}',
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              // Report Data
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  reportData.originalImage != null
                                      ? Image.network(
                                          reportData.originalImage!,
                                          width: screenWidth * 0.4,
                                          height: screenHeight * 0.2,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Image.asset('assets/screen.png', width: screenWidth * 0.4, height: screenHeight * 0.2);
                                          },
                                        )
                                      : Image.asset('assets/screen.png', width: screenWidth * 0.4, height: screenHeight * 0.2),
                                  SizedBox(width: screenWidth * 0.05),
                                  Text('Your Image', style: TextStyle(fontSize: screenWidth * 0.04)),
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
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Image.asset('assets/screen.png', width: screenWidth * 0.4, height: screenHeight * 0.2);
                                          },
                                        )
                                      : Image.asset('assets/doctor.jpeg', width: screenWidth * 0.4, height: screenHeight * 0.2),
                                  SizedBox(width: screenWidth * 0.05),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('AI Image', style: TextStyle(fontSize: screenWidth * 0.04)),
                                      SizedBox(height: screenHeight * 0.01),
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
                                    // Handle Consult doctor button press
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                    child: Text(
                                      'Consult doctor',
                                      style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
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
    );
  }
}
