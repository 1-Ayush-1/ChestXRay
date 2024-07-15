import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MessageContainer extends StatelessWidget {
  const MessageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 4),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Back',
                  style: TextStyle(fontSize: 14, color: Color(0xff4268b0)),
                ),
              ),
              SizedBox(width: 85),
              Text('Dr.John',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 24, color: Color(0xff4268b0))),
            ],
          ),
          SizedBox(height: 4),
          Positioned(
            top: 93,
            left: 21,
            child: ClipOval(
              child: Image.asset(
                'assets/images/doctor.jpeg',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 40),
          Container(
            height: 181,
            width: 349,
            decoration: BoxDecoration(
                color: Color(0xffcde2f5),
                borderRadius: BorderRadius.circular(8)),
            child: TextField(
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
                print(rating);
              },
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xff4268b0)),
              width: 266,
              height: 51,
              child: TextButton(
                onPressed: () {},
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
                onPressed: () {},
                child: Text(
                  'Not Now',
                  style: TextStyle(fontSize: 14, color: Color(0xff4268b0)),
                ),
              ),
            ),
          ),
        ], //children
      ),
    ); //container
  } //build context
}//stateless widget
