import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageContainer extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorImageUrl;

  const MessageContainer({
    Key? key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorImageUrl,
  }) : super(key: key);

  @override
  _MessageContainerState createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0;

  Future<void> _submitReview() async {
    final String apiUrl = 'https://your-backend-url.com/api/submit_review/';
    final String token = 'your_auth_token_here'; // Replace with actual token

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          'doctor_id': widget.doctorId,
          'review_text': _feedbackController.text,
          'rating': _rating,
        }),
      );

      if (response.statusCode == 201) {
        // Review submitted successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully')),
        );
      } else {
        // Error submitting review
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
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
        body: 
    
    
    Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 4),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back',
                  style: TextStyle(fontSize: 14, color: Color(0xff4268b0)),
                ),
              ),
              SizedBox(width: 85),
              Text(widget.doctorName,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 24, color: Color(0xff4268b0))),
            ],
          ),
          SizedBox(height: 4),
          ClipOval(
            child: Image.network(
              widget.doctorImageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
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
            child: Container(
              child: Text('Rate the doctor',
                  style: TextStyle(fontSize: 18, color: Color(0xff4268b0))),
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
                onPressed: _submitReview,
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
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
          ),
        ],
      ),
    ),
    
    );
  }
}