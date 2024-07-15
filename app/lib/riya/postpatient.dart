import 'package:check/riya/usermodel.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
        'PATCH', Uri.parse('http://51.20.3.117/users/patient_profile/'));
    request.headers['Authorization'] =
        'Token 0399e7febfd5bbf32b51272d30a902592f766ec8';
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
    print(userData.toString());
    final response = await http.patch(
      Uri.parse('http://51.20.3.117/users/patient_profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token 0399e7febfd5bbf32b51272d30a902592f766ec8'
      },
      body: userData,
    );
    if (response.statusCode == 200) {
      print('Details saved');
    } else {
      print(response.statusCode);
      throw Exception('Failed to save user details: ${response.statusCode}');
    }
  }
}

class Postpatient_Container extends StatefulWidget {
  final String staticId;
  final String token;

  const Postpatient_Container(
      {Key? key, required this.staticId, required this.token})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Postpatient_ContainerState createState() => _Postpatient_ContainerState();
}

class _Postpatient_ContainerState extends State<Postpatient_Container> {
  late Future<User> _userFuture;
  late ApiService _apiService;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _mobileNumberController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _medicationController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _addressController;
  late TextEditingController _pincodeController;
  
  

/////////////////////////////////////AYUSH
  // File? _imageFile;
  // const primary = Color(0xff4268b0);
  //   final userData = await _apiService.getUserData(widget.staticId);
  //   return User.fromJson(userData);
  // }
/////////////////////////////////////
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
  ////////////////////////////////////////////////
  void _initControllers() {
    _mobileNumberController = TextEditingController(text: '');
    _dateOfBirthController = TextEditingController(text: '');
    _medicationController = TextEditingController(text: '');
    _ageController = TextEditingController(text: '');
    _weightController = TextEditingController(text: '');
    _heightController = TextEditingController(text: '');
    _addressController = TextEditingController(text: '');
    _pincodeController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _dateOfBirthController.dispose();
    _medicationController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
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
      user.medication = _medicationController.text;
      user.weight = _weightController.text.isNotEmpty
          ? int.parse(_weightController.text)
          : null;
      user.height = _heightController.text.isNotEmpty
          ? int.parse(_heightController.text)
          : null;
      user.address = _addressController.text;
      user.pincode = _pincodeController.text;
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
          SnackBar(content: Text('Failed to save user details xyz')),
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
    _medicationController.text = user.medication ?? '';
    _weightController.text = user.weight != null ? user.weight.toString() : '';
    _heightController.text = user.height != null ? user.height.toString() : '';
    _addressController.text = user.address ?? '';
    _pincodeController.text = user.pincode ?? '';
  }

  Widget _buildUserForm(User user) {
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

  
      
    Form(
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
                    _medicationController, 'Medication', 'Medication'),
                _buildTextField(_weightController, 'Weight', 'Weight'),
                _buildTextField(_heightController, 'Height', 'Height'),
                _buildTextField(_addressController, 'Address', 'Address'),
                _buildTextField(_pincodeController, 'Pincode', 'Pincode'),
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
                      : AssetImage('assets/images/user.jpg')) as ImageProvider,
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
          padding: EdgeInsets.only(left: 3),
          alignment: Alignment.topLeft,
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
                floatingLabelAlignment: FloatingLabelAlignment.start),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
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
          alignment: Alignment.topLeft,
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
                floatingLabelAlignment: FloatingLabelAlignment.start),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
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
              alignment: Alignment.topLeft,
              width: 290.0,
              height: 34,
              decoration: BoxDecoration(
                  color: Color(0xffcde2f5),
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                scrollPadding: EdgeInsets.all(5),
                decoration: InputDecoration(
                    hintText: 'Enter Mobile number',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    floatingLabelAlignment: FloatingLabelAlignment.start),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            Padding(padding: EdgeInsets.all(3)),
            Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff4268b0)),
              width: 60,
              height: 32,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'phone/');
                },
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
}
