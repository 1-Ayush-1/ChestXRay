import 'package:check/riya/usermodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:myapp/usermodel.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
  final String baseUrl = 'http://51.20.3.117/';
  final String? token;
  ApiService({required this.token});

  Future<Map<String, dynamic>> getUserData(String staticId) async {
    {
      var url = Uri.parse('http://51.20.3.117/users/user_details/');
      http.Response response = await http.get(url, headers: {
        'Authorization': 'Token 0399e7febfd5bbf32b51272d30a902592f766ec8'
      });

      try {
        if (response.statusCode == 200) {
          print("got 200");
          var decodedData = jsonDecode(response.body);
          return decodedData;
        } else {
          throw Exception("failure");
        }
      } catch (e) {
        throw Exception("failure");
      }
    }
  }

  Future<String> uploadProfilePicture(File imageFile, String staticId) async {
    var request = http.MultipartRequest(
        'PATCH', Uri.parse('http://51.20.3.117/users/doctor_profile/'));
    request.headers['Authorization'] = 'Token ';
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonData = json.decode(responseString);
      return jsonData['imageUrl'];
    } else {
      throw Exception('Failed to upload profile picture');
    }
  }

  Future<void> saveUserDetails(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('http://51.20.3.117/users/doctor_profile/'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Token '},
      body: json.encode(userData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to save user details');
    }
  }
}

class Postdoctor_Container extends StatefulWidget {
  final String staticId;
  final String token;

  const Postdoctor_Container(
      {Key? key, required this.staticId, required this.token})
      : super(key: key);

  @override
  _Postdoctor_ContainerState createState() => _Postdoctor_ContainerState();
}

class _Postdoctor_ContainerState extends State<Postdoctor_Container> {
  late Future<User> _userFuture;
  late ApiService _apiService;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _mobileNumberController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _qualificationController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  late TextEditingController _aboutController;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(token: widget.token);
    _userFuture = _fetchUserData();
    _initControllers();
  }

  Future<User> _fetchUserData() async {
    final userData = await _apiService.getUserData(widget.staticId);
    return User.fromJson(userData);
  }

  void _initControllers() {
    _mobileNumberController = TextEditingController(text: '');
    _dateOfBirthController = TextEditingController(text: '');
    _qualificationController = TextEditingController(text: '');
    _ageController = TextEditingController(text: '');
    _addressController = TextEditingController(text: '');
    _aboutController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _dateOfBirthController.dispose();
    _qualificationController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProfilePicture(User user) async {
    if (_imageFile != null) {
      try {
        final imageUrl =
            await _apiService.uploadProfilePicture(_imageFile!, user.staticId!);
        setState(() {
          user.profilePhoto = imageUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture uploaded successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload profile picture')),
        );
      }
    }
  }

  Future<void> _saveUserDetails(User user) async {
    if (_formKey.currentState!.validate()) {
      user.mobileNum = _mobileNumberController.text;
      user.dob = _dateOfBirthController.text;
      user.qualification = _qualificationController.text;
      user.about = _aboutController.text;
      if (_imageFile != null) {
        await _uploadProfilePicture(user);
      }
      try {
        await _apiService.saveUserDetails(user.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User details saved successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save user details')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error.toString()}');
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return _buildUserForm(user);
        } else {
          return Text('No user data available');
        }
      },
    );
  }

  void _initializeTextControllers(User user) {
    _mobileNumberController.text = user.mobileNum ?? '';
    _dateOfBirthController.text = user.dob ?? '';
    _qualificationController.text = user.qualification ?? '';
    _aboutController.text = user.about != null ? user.about.toString() : '';
    _addressController.text = user.address ?? '';
  }

  Widget _buildUserForm(User user) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // User info section (name, email, ID)
                _buildUserInfo(user),
                _build3TextField(
                    _mobileNumberController, 'Mobile number', 'Mobile number'),
                _buildTextField(
                    _dateOfBirthController, 'Date of Birth', 'Date of Birth'),
                _buildTextField(_ageController, 'Age', 'Age'),
                _build2TextField(
                    _qualificationController, 'qualification', 'qualification'),
                _build2TextField(_aboutController, 'about', 'about'),
                _buildTextField(_addressController, 'Address', 'Address'),
                SizedBox(
                  height: 20,
                ),
                // Save and Back buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xff4268b0)),
                      width: 150,
                      height: 32,
                      child: TextButton(
                        onPressed: () => _saveUserDetails(user),
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xff4268b0)),
                      width: 150,
                      height: 32,
                      child: TextButton(
                        onPressed: () {
                          // Implement back functionality
                          Navigator.pushNamed(context, 'patient_menu/');
                        },
                        child: Text(
                          'Back',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : (user.profilePhoto != null
                      ? NetworkImage(user.profilePhoto!)
                      : AssetImage('assets/user.jpg')) as ImageProvider,
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(user.email!),
              // SizedBox(height: 5),
              // Text(user.staticId!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, String label) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(8)),
        Container(
          padding: EdgeInsets.all(3),
          alignment: Alignment.center,
          width: 290.0,
          height: 34,
          decoration: BoxDecoration(
            color: Color(0xffcde2f5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ),
      ],
    );
  }
}

Widget _build3TextField(
    TextEditingController controller, String labelText, String label) {
  return Column(
    children: [
      Padding(padding: EdgeInsets.all(8)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(8)),
          Container(
            padding: EdgeInsets.all(3),
            alignment: Alignment.center,
            width: 290.0,
            height: 34,
            decoration: BoxDecoration(
                color: Color(0xffcde2f5),
                borderRadius: BorderRadius.circular(8)),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter Mobile number',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Padding(padding: EdgeInsets.all(6)),
          Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xff4268b0)),
            width: 60,
            height: 32,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Verify',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _build2TextField(
    TextEditingController controller, String labelText, String label) {
  return Column(
    children: [
      Padding(padding: EdgeInsets.all(8)),
      Container(
        padding: EdgeInsets.all(3),
        alignment: Alignment.center,
        width: 290.0,
        height: 114,
        decoration: BoxDecoration(
          color: Color(0xffcde2f5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    ],
  );
}



// // enum GenderGroup {
// //   male,
// //   female,
// //   other,
// // }

// // class DoctorContainerbox extends StatefulWidget {
// //   const DoctorContainerbox({Key? key}) : super(key: key);

// //   @override
// //   _DoctorContainerboxState createState() => _DoctorContainerboxState();
// // }

// // class _DoctorContainerboxState extends State<DoctorContainerbox> {
// //   Set<GenderGroup> _selectedValues = {};

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Text('Gender'),
// //         CheckboxListTile(
// //           value: _selectedValues.contains(GenderGroup.male),
// //           title: Text('Male'),
// //           onChanged: (bool? val) {
// //             setState(() {
// //               if (val == true) {
// //                 _selectedValues.add(GenderGroup.male);
// //               } else {
// //                 _selectedValues.remove(GenderGroup.male);
// //               }
// //             });
// //             print(_selectedValues);
// //           },
// //         ),
// //         CheckboxListTile(
// //           value: _selectedValues.contains(GenderGroup.female),
// //           title: Text('Female'),
// //           onChanged: (bool? val) {
// //             setState(() {
// //               if (val == true) {
// //                 _selectedValues.add(GenderGroup.female);
// //               } else {
// //                 _selectedValues.remove(GenderGroup.female);
// //               }
// //             });
// //             print(_selectedValues);
// //           },
// //         ),
// //         CheckboxListTile(
// //           value: _selectedValues.contains(GenderGroup.other),
// //           title: Text('Other'),
// //           onChanged: (bool? val) {
// //             setState(() {
// //               if (val == true) {
// //                 _selectedValues.add(GenderGroup.other);
// //               } else {
// //                 _selectedValues.remove(GenderGroup.other);
// //               }
// //             });
// //             print(_selectedValues);
// //           },
// //         ),
// //       ],
// //     );
// //   } // build Context
// // } // DoctorContainerBox

                 