import 'package:flutter/material.dart';
import 'api_service.dart';
import 'image_model_doc.dart';

class ReportDetailDocPage extends StatefulWidget {
  
  final String? reportStaticId;
  final String token;

  const ReportDetailDocPage({Key? key,  required this.reportStaticId, required this.token}) : super(key: key);

  @override
  _ReportDetailDocPageState createState() => _ReportDetailDocPageState();
}

class _ReportDetailDocPageState extends State<ReportDetailDocPage> {
  late Future<Map<String, dynamic>> _futureUserData;
  late Future<ImageDocData> _futureReportData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      _futureUserData = ApiService().fetchUserData(widget.token);
      _futureReportData = ApiService().fetchReportDocData(widget.reportStaticId!);

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: AppBar(
          backgroundColor: Colors.blue,
          title: FutureBuilder<Map<String, dynamic>>(
            future: _futureUserData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final userData = snapshot.data!;
                return Container(
                  color: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: userData['profile_pic'] != null
                            ? NetworkImage(userData['profile_pic'])
                            : AssetImage('assets/screen.png') as ImageProvider,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hello, ${userData['name']}!',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '@${userData['static_id']}',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>>(
              future: _futureUserData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
  //unnati                final userData = snapshot.data!;                  
                  return FutureBuilder<ImageDocData>(
                    future: _futureReportData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final reportData = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Original Image and 'Your Image' row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  reportData.originalImage != null
                                      ? Image.network(
                                          reportData.originalImage!,
                                          width: 150,
                                          height: 150,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Image.asset('assets/screen.png');
                                          },
                                        )
                                      : Image.asset('assets/screen.png'),
                                  const SizedBox(width: 20),
                                  const Text('Your Image', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // AI Image and AI Text row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  reportData.aiImage != null
                                      ? Image.network(
                                          reportData.aiImage!,
                                          width: 150,
                                          height: 150,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Image.asset('assets/screen.png');
                                          },
                                        )
                                      : Image.asset('assets/screen.png'),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('AI Image', style: TextStyle(fontSize: 16)),
                                      const SizedBox(height: 10),
                                      Text(reportData.aiText!),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Doctor's Comments
                              Container(
                                padding: EdgeInsets.all(12.0),
                                color: Colors.lightBlue[100],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Doctor\'s Comments',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      reportData.doctorComments!,
                                      style: TextStyle(fontSize: 16, color: Colors.black),
                                    ),
                                    SizedBox(height: 12),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, 'give_review/');
                                      },
                                      child: Text(
                                        'Give Reviews',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue, decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  ],
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
