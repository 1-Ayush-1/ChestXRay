import 'package:check/Sourish/services/doctor_info_store.dart';
import 'package:check/saumya/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class MessageContainer extends StatefulWidget {
  final String? doctorId;
  final String? doctorName;
  final String? doctorImageUrl;
  final String token;
  final String reportStaticId;

  MessageContainer({
    Key? key,
    this.doctorId,
    this.doctorName,
    this.doctorImageUrl,
    required this.token,
    required this.reportStaticId,
  }) : super(key: key);

  @override
  _MessageContainerState createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0;

  Future<void> _submitReview(String randomId) async {
    final String apiUrl = 'http://51.20.3.117/api/reviews/create_review/';
    final doctorInfo = DoctorInfoStore.doctorInfoMap[widget.reportStaticId];

    if (doctorInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doctor information not found')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${widget.token}',
        },
        body: jsonEncode({
          'static_id': widget.reportStaticId,
          'patient': randomId,
          'doctor': doctorInfo['doctorId'] ?? '', // Provide a default value if null
          'review_comment': _feedbackController.text,
          'rating_stars': _rating.toInt(),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4268b0),
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Back',
                          style: TextStyle(fontSize: 14, color: Color(0xff4268b0)),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          ClipOval(
                            child: widget.doctorImageUrl != null
                                ? Image.network(
                                    widget.doctorImageUrl!,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/doctor.jpeg',
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'assets/doctor.jpeg',
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.doctorName ?? 'Doctor',
                            style: TextStyle(fontSize: 24, color: Color(0xff4268b0)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Container(
                  height: 181,
                  width: 349,
                  decoration: BoxDecoration(
                    color: Color(0xffcde2f5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _feedbackController,
                    scrollPadding: EdgeInsets.all(10),
                    decoration: InputDecoration(
                      hintText: 'Please provide your valuable feedback',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Rate the doctor',
                    style: TextStyle(fontSize: 18, color: Color(0xff4268b0)),
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Color(0xff4268b0),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0xff4268b0),
                    ),
                    width: 266,
                    height: 51,
                    child: TextButton(
                      onPressed: () {
                        if (user != null) {
                          _submitReview(user.staticId);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User not found')),
                          );
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Not Now',
                      style: TextStyle(fontSize: 14, color: Color(0xff4268b0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        },
        currentIndex: 0,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
