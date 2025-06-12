import 'package:check/Sourish/Screens/doctor_detail_screen.dart';
import 'package:check/Sourish/Screens/doctor_model.dart';
import 'package:check/Sourish/Screens/qr_scanner.dart';
import 'package:check/Sourish/services/doctor_service.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
 String? reportId;
 SearchScreen({super.key, this.reportId});
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  
  late Future<List<Doctor>> futureDoctors;
  List<Doctor> allDoctors = [];
  List<Doctor> filteredDoctors = [];
  TextEditingController searchController = TextEditingController();
  
  Future<void> _scanQR() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => QRViewExample()),
  );
  if (result != null) {
    try {
      Doctor doctor = await DoctorService().fetchDoctorById(result);
      Navigator.pushNamed(
        context,
        'doctor_detail/',
        arguments: doctor,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Invalid QR code or doctor not found')),
      );
    }
  }
}

  @override
  void initState() {
    super.initState();
    futureDoctors = DoctorService().fetchDoctors() as Future<List<Doctor>>;
    futureDoctors.then((doctors) {
      setState(() {
        allDoctors = doctors;
        filteredDoctors = doctors;
      });
    });
  }
  
  void filterDoctors(String query) {
    final List<Doctor> filteredList = allDoctors.where((doctor) {
      
      final doctorName = doctor.name.toLowerCase();
      final searchQuery = query.toLowerCase();
      return doctorName.contains(searchQuery);
    }).toList();

    setState(() {
      filteredDoctors = filteredList;
    });
  }
  //usko latest static id pta hai
  //
  
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
      title: Text('Select Doctor'),
      centerTitle: true,
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Type Doctor's Name",
                    fillColor: Colors.blue[50],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: filterDoctors,
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _scanQR,
                child: Icon(Icons.qr_code_scanner),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(15),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Doctor>>(
            future: futureDoctors,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load doctors'));
              } else {
                return ListView.builder(
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = filteredDoctors[index];
                    return Card(
                      shadowColor: Colors.blue,
                      color: Colors.blueAccent,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        iconColor: Colors.blue,
                        selectedTileColor: Colors.blue,
                        selectedColor: Colors.blueAccent,
                        leading: CircleAvatar(
                          radius: 30,
                          // child: Image.file(
                          //   doctor.profilePhotoUrl!,
                          //   width: 200,
                          //   height: 200,
                          //   fit: BoxFit.cover,
                          // ),
                          backgroundImage: doctor.profilePhotoUrl != null
                              ? NetworkImage(doctor.profilePhotoUrl!)
                              : AssetImage('assets/user.jpg'),
                          child: doctor.profilePhotoUrl == null
                              ? Text(doctor.name[0])
                              : null,
                          
                        ),
                        
                        title: Text(doctor.name),
                        
                        subtitle: Text(
                          doctor.about,
                          
                          // doctor.profilePhotoUrl!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            Text(doctor.rating.toStringAsFixed(1)),
                          ],
                        ),
                        onTap: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   'doctor_detail/',
                          //   arguments: doctor,
                          // );

                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DoctorDetailScreen(
                                                // token: widget.token,
                                                doctor: doctor,
                                                reportId: widget.reportId, 
                                              ),
                                            ),
                                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    ),
  );
}
}