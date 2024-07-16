import 'package:check/saumya/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'image_model_doc.dart';
import 'package:check/vaibhav/chat.dart'; // Import your ChatScreen

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
      // Fetch updated report data after comment update
      _futureReportData = ApiService().fetchReportDocData(widget.reportId!);
      setState(() {}); // Trigger a rebuild to update the UI with new comments
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

    // Accessing user data from UserProvider
    final user = userProvider.user;
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0), // Adjust height as needed
          child: AppBar(
            backgroundColor: Color(0xff4268b0),
            title: FutureBuilder<Map<String, dynamic>>(
              future: _futureUserData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final userData = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: (user!.profilePhoto) != null
                              ? NetworkImage(user.profilePhoto!)
                              : AssetImage('assets/screen.png') as ImageProvider,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hello, ${user!.name}!',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
            : FutureBuilder<ImageDocData>(
                future: _futureReportData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final reportData = snapshot.data!;
                    // _commentsController.text = reportData.doctorComments ?? 'No comments';

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
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) =>
                                          Image.asset('assets/screen.png'),
                                    )
                                  : Image.asset('assets/screen.png'),
                              SizedBox(width: 20),
                              Text('Your Image', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 20),
                          // AI Image and AI Text row
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
                          SizedBox(height: 20),
                          // Doctor's Comments
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(12.0),
                                color: Colors.lightBlue[100],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Doctor\'s Comments',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller: _commentsController,
                                      maxLines: 9,
                                      decoration: InputDecoration(
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
                                        SizedBox(width: 120),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ChatScreen()),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue, // Change button color to blue
                                          ),
                                          child: Text('Chat with doctor'),
                                        ),
                                      ],
                                    ),
                                  ],
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
              ),
      ),
    );
  }
}
