import 'package:check/saumya/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';



class PatientSearchScreen extends StatefulWidget {
  const PatientSearchScreen({super.key});

  @override
  State<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends State<PatientSearchScreen> {
  String doctorName = '';
  List patients = [];
  List filteredPatients = [];
  String doctorImageUrl = '';
  String token = "";
  

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
    fetchPatients();
    // token = widget.user.toke;
  }

  Future<void> fetchDoctorDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://51.20.3.117/users/doctortanish/'),
        headers: {
          'Authorization': 'Token 42def62adfe6c14903943810eccca05ad8b84cdf',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          doctorName = data['name'];
          doctorImageUrl = 'http://51.20.3.117' + data['profile_photo'];
        });
        print('Doctor image URL: $doctorImageUrl');
      } else {
        print('Failed to load doctor details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctor details: $e');
    }
  }

  Future<void> fetchPatients() async {
    try {
      final response = await http.get(
        Uri.parse('http://51.20.3.117/users/patients/'),
        headers: {
          'Authorization': 'Token 42def62adfe6c14903943810eccca05ad8b84cdf',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          patients = data;
          filteredPatients = data;
        });
        print('Fetched patients: $patients');
      } else {
        print('Failed to load patients: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching patients: $e');
    }
  }

  void navigateToAnotherScreen() {
    // Example navigation logic
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OtherScreen()), // Replace OtherScreen with the actual screen you want to navigate to
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // Accessing user data from UserProvider
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $doctorName!'),
        backgroundColor: Colors.blue,
        leading: doctorImageUrl.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  doctorImageUrl,
                ),
              )
            : const CircleAvatar(
                child: Icon(Icons.person),
              ),
      ),
      body: Column(
        
        children: [
          
          // void initState(){
          // token = user.token;
          // }
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: navigateToAnotherScreen,
              child: const Text(
                'Search Patient',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                final patientImageUrl = patient['original_image_url'].startsWith('http')
                    ? patient['original_image_url']
                    : 'http://51.20.3.117' + patient['original_image_url'];
                print('Patient image URL: $patientImageUrl');
                return PatientCard(patient: patient, patientImageUrl: patientImageUrl);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation
        },
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final Map patient;
  final String patientImageUrl;

  const PatientCard({required this.patient, required this.patientImageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: patientImageUrl.isNotEmpty
            ? Image.network(
                patientImageUrl,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading patient image: $error');
                  return const Icon(Icons.error);
                },
              )
            : const Icon(Icons.person),
        title: Text(patient['patient_name']),
        subtitle: const Text('Add a description which can describe about the video. Some other information...'),
      ),
    );
  }
}

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Screen'),
      ),
      body: const Center(
        child: Text('This is another screen.'),
      ),
    );
  }
}


