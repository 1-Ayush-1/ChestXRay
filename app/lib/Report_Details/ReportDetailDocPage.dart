import 'dart:convert';

import 'package:check/Upload_Image/profileheader.dart';
import 'package:check/Upload_Image/usermenu.dart';
import 'package:check/Doctor_Patient_Detail/postmessage.dart';
import 'package:check/User_Verification/user_provider.dart';
import 'package:check/App_Chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'image_model_doc.dart';

class ReportDetailDocPage extends StatefulWidget {
  final String reportStaticId;
  final String token;
  final String? doctorId;
  final String? doctorName;
  final String? doctorImageUrl;

  ReportDetailDocPage(
      {Key? key,
      required this.reportStaticId,
      required this.token,
      this.doctorId,
      this.doctorImageUrl,
      this.doctorName})
      : super(key: key);

  @override
  _ReportDetailDocPageState createState() => _ReportDetailDocPageState();
}

class _ReportDetailDocPageState extends State<ReportDetailDocPage> {
  late Future<Map<String, dynamic>> _futureUserData;
  late Future<ImageDocData> _futureReportData;
  bool isLoading = true;
  String occupation = 'patient';

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  
  Future<void> create_chat() async {
    String url = 'http://51.20.3.117/api/chat/create_chat/';

    occupation='patient';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${widget.token}',
        },
        body: jsonEncode({
          'static_id': widget.reportStaticId
        }),
      );
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      String chatStaticId = jsonResponse['static_id']; // Access the specific field

      print('Sending POST request to: $url');
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              token: widget.token,
              chatStaticId: chatStaticId,
              occupation: occupation,
              Namee: widget.doctorName,
            ),
          ),
        );
      } else {
        print('Failed to send. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sending message: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Failed to connect to the server. Please check your connection."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> fetchData() async {


    print("check karo ${widget.reportStaticId}");
    print(widget.doctorId);
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
    final userProvider = Provider.of<UserProvider>(context);
    final userzz = userProvider.user;
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      
      drawer: MenuDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _futureUserData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return FutureBuilder<ImageDocData>(
                      future: _futureReportData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final reportData = snapshot.data!;
                          return Padding(
                            
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileHeader(),
                                SizedBox(height: 5),
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
                                        if (reportData.aiText != null) Text(reportData.aiText!) else Text(""),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(12.0),
                                  height: 260,
                                  width: screenWidth,
                                  color: Colors.lightBlue[100],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Doctor\'s Comments',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        reportData.doctorComments!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Spacer(),
                                      Center(
                                        child: GestureDetector(
                                          onTap:(){
                                            create_chat();
                                          } ,
                                          child: const Text(
                                            'Chat with me',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(255, 63, 136, 195),
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (reportData.doctorComments != "No Comments")
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MessageContainer(
                                            doctorId: widget.doctorId!,
                                            doctorName: widget.doctorName!,
                                            doctorImageUrl: widget.doctorImageUrl!,
                                            token: userzz!.token,
                                            reportStaticId: widget.reportStaticId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Give review',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 63, 136, 195),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MessageContainer(
                                              doctorId: widget.doctorId,
                                              doctorName: widget.doctorName,
                                              doctorImageUrl: widget.doctorImageUrl,
                                              token: userzz!.token,
                                              reportStaticId: widget.reportStaticId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Give review',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 63, 136, 195),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        } else {
                          return Center(child: Text('No report available'));
                        }
                      },
                    );
                  } else {
                    return Center(child: Text('No user data available'));
                  }
                },
              ),
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
        currentIndex: 0,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
