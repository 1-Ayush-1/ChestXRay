import 'dart:convert';
import 'package:check/Upload_Image/profileheader.dart';
import 'package:check/Upload_Image/usermenu.dart';
import 'package:check/User_Verification/user_provider.dart';
import 'package:check/App_Chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'api_service.dart';
import 'image_model_doc.dart';

class UpdateDoc extends StatefulWidget {
  final String? reportId;
  final String token;

  const UpdateDoc({Key? key, required this.reportId, required this.token}) : super(key: key);

  @override
  _UpdateDocState createState() => _UpdateDocState();
}

class _UpdateDocState extends State<UpdateDoc> {
  late Future<Map<String, dynamic>> _futureUserData;
  late Future<ImageDocData> _futureReportData;
  bool isLoading = true;
  final TextEditingController _commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> create_chat(String occupation) async {
    String url = 'http://51.20.3.117/api/chat/create_chat/';
    occupation = 'doctor';  
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${widget.token}',
        },
        body: jsonEncode({
          'static_id': widget.reportId
        }),
      );

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      String chatStaticId = jsonResponse['static_id'];

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatScreen(
                  token: widget.token,
                  chatStaticId: chatStaticId,
                  occupation: occupation,
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
    try {
      _futureUserData = ApiService().fetchUserData(widget.token);
      _futureReportData = ApiService().fetchReportDocData(widget.reportId!);

      await Future.wait([_futureUserData, _futureReportData]);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateDoctorComments() async {
    ApiService apiService = ApiService();
    try {
      await apiService.updateDoctorCommentsU(
        widget.reportId!,
        _commentsController.text.toString(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comments updated successfully')),
      );
      _futureReportData = ApiService().fetchReportDocData(widget.reportId!);
      setState(() {});
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update comments')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userzzz = userProvider.user;
    String occupation;
    if (userzzz!.occupation == 'Doc')
      occupation = "doctor";
    else
      occupation = 'patient';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        drawer: MenuDrawer(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: FutureBuilder<ImageDocData>(
                  future: _futureReportData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final reportData = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileHeader(),
                            // Display profile header, original image, AI image, doctor's comments, and chat button
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                reportData.originalImage != null
                                    ? Image.network(
                                        reportData.originalImage!,
                                        width: 150,
                                        height: 150,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) =>
                                            Image.asset('assets/screen.png'),
                                      )
                                    : Image.asset('assets/screen.png'),
                                SizedBox(width: 20),
                                Text('Your Image', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                reportData.aiImage != null
                                    ? Image.network(
                                        reportData.aiImage!,
                                        width: 150,
                                        height: 150,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) =>
                                            Image.asset('assets/screen.png'),
                                      )
                                    : Image.asset('assets/screen.png'),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('AI Image', style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 10),
                                    Text(reportData.aiText ?? ''), // Show AI text if available
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Doctor\'s Comments',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: _commentsController,
                              maxLines: 9,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 182, 211, 235),
                                border: OutlineInputBorder(),
                                hintText: 'Enter your comments here...',
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await updateDoctorComments();
                                    } catch (e) {
                                      print('Error updating comments: $e');
                                    }
                                  },
                                  child: Text('Submit'),
                                ),
                                SizedBox(width: 60),
                                ElevatedButton(
                                  onPressed: () {
                                    create_chat(occupation);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text('Chat with Patient'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: Text('No report available'));
                    }
                  },
                ),
              ),
      ),
    );
  }
}
