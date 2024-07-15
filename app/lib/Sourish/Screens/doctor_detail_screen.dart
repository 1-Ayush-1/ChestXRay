// lib/screens/doctor_detail_screen.dart

import 'package:check/Sourish/Screens/doctor_model.dart';
import 'package:check/Sourish/services/doctor_service.dart';
import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Doctor doctor;
  DoctorDetailScreen({required this.doctor});

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.doctor.name),
              background: Container(
                color: Colors.blue,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(),
                  SizedBox(height: 20),
                  _buildInfoSection("Who Am I ?", widget.doctor.about),
                  SizedBox(height: 20),
                  _buildQualificationSection(),
                  SizedBox(height: 20),
                  _buildReviewsSection(),
                  SizedBox(height: 20),
                  _buildReviewForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doctor.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('@${widget.doctor.name.toLowerCase().replaceAll(' ', '')}'),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(' ${widget.doctor.rating} • ${widget.doctor.address}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(content),
      ],
    );
  }

  Widget _buildQualificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Qualification",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text("• ${widget.doctor.description}"),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return FutureBuilder<List<Review>>(
      future: DoctorService().fetchReviews(widget.doctor.staticId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No reviews yet.');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reviews",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...snapshot.data!.map((review) => _buildReviewItem(review)).toList(),
            ],
          );
        }
      },
    );
  }

  Widget _buildReviewItem(Review review) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(review.patient, style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                Row(
                  children: List.generate(5, (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  )),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(review.comment),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Write a Review",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _reviewController,
            decoration: InputDecoration(
              hintText: "Enter your review here",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a review';
              }
              return null;
            },
          ),
          SizedBox(height: 8),
          Text("Rating:"),
          Slider(
            value: _rating,
            min: 0,
            max: 5,
            divisions: 5,
            label: _rating.round().toString(),
            onChanged: (double value) {
              setState(() {
                _rating = value;
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitReview,
            child: Text('Submit Review'),
          ),
        ],
      ),
    );
  }

  void _submitReview() async {
    if (_formKey.currentState!.validate()) {
      try {
        final result = await DoctorService().submitReview(
          widget.doctor.staticId,
          'patient_id_here', // You need to implement a way to get the current patient's ID
          _reviewController.text,
          _rating.round(),
        );
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Review submitted successfully')),
          );
          _reviewController.clear();
          setState(() {
            _rating = 0;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review: $e')),
        );
      }
    }
  }
}




// class DoctorDetailScreen extends StatelessWidget {
//   final Doctor doctor;

//   DoctorDetailScreen({required this.doctor});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(doctor.name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage('C:\Users\souri\OneDrive\Desktop\EEE\Other\PS1'), // Ensure you have imageUrl in the model or manage it accordingly.
//                     radius: 30,
//                   ),
//                   SizedBox(width: 16),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         doctor.name,
//                         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                       // Text(doctor.sex == 'M' ? 'Male' : doctor.sex == 'F' ? 'Female' : 'Other'),
//                       // Text('Age: ${doctor.age}'),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Who Am I?',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(doctor.about),
//               SizedBox(height: 16),
//               Text(
//                 'My Qualification',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(doctor.description),
//               SizedBox(height: 16),
//               Text(
//                 'Contact Information',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text('Email: ${doctor.email}'),
//               Text('Mobile: ${doctor.mobileNum}'),
//               Text('Address: ${doctor.address}'),
//               Text('Pincode: ${doctor.pincode}'),
//               SizedBox(height: 16),
//               Text(
//                 'Reviews',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.star, color: Colors.amber),
//                   Text('${doctor.rating} out of 5'),
//                 ],
//               ),
//               // Add reviews list here if necessary
//               Spacer(),
//               ElevatedButton(
//                 onPressed: () {
//                   // Handle button press
//                 },
//                 child: Text('Send to Doctor'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
