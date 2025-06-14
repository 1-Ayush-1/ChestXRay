import 'package:check/Upload_Image/profileheader.dart';
import 'package:check/Upload_Image/usermenu.dart';
import 'package:check/Report_Details/update_doc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientSearchScreen extends StatefulWidget {
  final String token;

  PatientSearchScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends State<PatientSearchScreen> {
  String doctorName = '';
  List patients = [];
  List filteredPatients = [];
  String doctorImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
    fetchPatients();
  }

  Future<void> fetchDoctorDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://51.20.3.117/api/users/doctortanish/'),
        headers: {
          'Authorization': 'Token ${widget.token}',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          doctorName = data['name'];
          doctorImageUrl = 'http://51.20.3.117/api' + data['profile_photo'];
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
        Uri.parse('http://51.20.3.117/api/users/patients/'),
        headers: {
          'Authorization': 'Token ${widget.token}',
        },
      );
      print(response.body);
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

  void filterPatients(String query) {
    List<Map<String, dynamic>>? filteredList = [];
    if (query.isNotEmpty) {
      filteredList = patients.where((patient) {
        final patientName =
            patient['patient_name'].toString().toLowerCase();
        return patientName.contains(query.toLowerCase());
      }).cast<Map<String, dynamic>>().toList();
    } else {
      filteredList = List.from(patients);
    }
    setState(() {
      filteredPatients = filteredList!.cast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      // appBar: AppBar(
      //   title: Text('Patient Search'),
      // ),
      body: Column(
        children: [
          ProfileHeader(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  onChanged: (value) => filterPatients(value),
                  decoration: InputDecoration(
                    hintText: 'Search Patients...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                final patientImageUrl =
                    patient['original_image_url'].startsWith('http')
                        ? patient['original_image_url']
                        : 'http://51.20.3.117/api' +
                            patient['original_image_url'];
                print('Patient image URL: $patientImageUrl');
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateDoc(
                                      reportId: patient['image_static_id'],
                                      token: widget.token,
                                      
                                    ),
                                  ),
                                );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        child: patientImageUrl.isNotEmpty
                            ? Image.network(
                                patientImageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading patient image: $error');
                                  return const Icon(Icons.error);
                                },
                              )
                            : const Icon(Icons.person),
                      ),
                      title: Text(patient['patient_name']),
                      subtitle: const Text(
                          'Add a description which can describe about the video. Some other information...'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PatientProfileScreen extends StatelessWidget {
  final Map patient;
  final String patientImageUrl;

  const PatientProfileScreen({
    required this.patient,
    required this.patientImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient['patient_name']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            patientImageUrl.isNotEmpty
                ? Image.network(
                    patientImageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading patient image: $error');
                      return const Icon(Icons.error);
                    },
                  )
                : const Icon(Icons.person, size: 120),
            const SizedBox(height: 16),
            Text('Patient Name: ${patient['patient_name']}'),
            const SizedBox(height: 8),
            Text('Patient ID: ${patient['patient_id']}'),
            // Add more patient details as needed
          ],
        ),
      ),
    );
  }
}
