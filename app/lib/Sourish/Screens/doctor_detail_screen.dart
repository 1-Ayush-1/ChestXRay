import 'dart:convert';
import 'package:check/Sourish/services/doctor_info_store.dart';
import 'package:http/http.dart' as http;
import 'package:check/Sourish/Screens/doctor_model.dart';
import 'package:check/Sourish/services/doctor_service.dart';
import 'package:check/saumya/user_provider.dart';
import 'package:check/unnati/ReportDetailDocPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Doctor doctor;
  final String? reportId;

  DoctorDetailScreen({required this.doctor, this.reportId});

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.reportId != null) {
      DoctorInfoStore.doctorInfoMap[widget.reportId!] = {
        'doctorId': widget.doctor.staticId,
        'doctorImageUrl': widget.doctor.profilePhotoUrl ?? 'default_url', // Provide a default URL
        'doctorName': widget.doctor.name ?? 'Unknown', // Provide a default name
      };
    }
  }

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
              title: Text(widget.doctor.name ?? 'Doctor'),
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
                  _buildInfoSection("Who Am I ?", widget.doctor.about ?? 'No information available'),
                  SizedBox(height: 20),
                  _buildQualificationSection(),
                  SizedBox(height: 20),
                  // _buildReviewsSection(),
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
          child: widget.doctor.profilePhotoUrl != null
              ? ClipOval(
                  child: Image.network(
                    widget.doctor.profilePhotoUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: 80, color: Colors.grey[600]);
                    },
                  ),
                )
              : Icon(Icons.person, size: 80, color: Colors.grey[600]),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doctor.name ?? 'Unknown',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('@${widget.doctor.name?.toLowerCase().replaceAll(' ', '') ?? 'unknown'}'),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '${widget.doctor.rating ?? 'N/A'} • ${widget.doctor.address ?? 'No address'}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
        Text("• ${widget.doctor.description ?? 'No description'}"),
      ],
    );
  }

  Widget _buildReviewForm() {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    Future<void> sendToDoctor(BuildContext context, String? imageStaticId, String doctorStaticId, String token) async {
      print("Sending to doctor:");
      print("Image Static ID: $imageStaticId");
      print("Token: $token");
      print("Doctor Static ID: $doctorStaticId");

      try {
        final response = await http.patch(
          Uri.parse('http://51.20.3.117/api/images/post_images_to_doctor/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          },
          body: jsonEncode({
            'image_static_id': imageStaticId,
            'doctor_id': doctorStaticId,
          }),
        );

        print(response.body);

        if (response.statusCode == 200) {
          print('Details saved');

          // Update the DoctorInfoStore with the new doctor info
          if (imageStaticId != null) {
            DoctorInfoStore.doctorInfoMap[imageStaticId] = {
              'doctorId': doctorStaticId,
              'doctorImageUrl': widget.doctor.profilePhotoUrl ?? 'default_url',
              'doctorName': widget.doctor.name ?? 'Unknown',
            };
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportDetailDocPage(
                reportStaticId: imageStaticId!,
                token: token,
                doctorId: doctorStaticId,
                doctorImageUrl: widget.doctor.profilePhotoUrl,
                doctorName: widget.doctor.name,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save details: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while sending details')),
        );
      }
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (user != null) {
                sendToDoctor(context, widget.reportId, widget.doctor.staticId, user.token);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User not found')),
                );
              }
            },
            child: Text('Send to Doctor'),
          ),
        ],
      ),
    );
  }
}
