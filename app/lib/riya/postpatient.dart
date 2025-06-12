import 'package:check/riya/usermodel.dart';
import 'package:check/saumya/user_provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:myapp/usermodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import 'package:check/saumya/user_provider.dart';

class ApiService {
  final String baseUrl = 'http://51.20.3.117/api/';
  final String? token;
  ApiService({required this.token});

  Future<Map<String, dynamic>> getUserData(String staticId, String randomtoken) async {
    {
      var url = Uri.parse('http://51.20.3.117/api/users/user_details/');
      http.Response response =
          await http.get(url, headers: {'Authorization': 'Token $randomtoken'});

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

  Future<String> uploadProfilePicture(
      File imageFile, String staticId, String randomtoken) async {
    var request = http.MultipartRequest(
        'PATCH', Uri.parse('http://51.20.3.117/api/users/patient_profile/'));
    request.headers['Authorization'] = 'Token $randomtoken';
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
  //print(userData);
  Future<void> saveUserDetails(
      Map<String, dynamic> userData, String randomtoken) async {
    print(userData.toString());
    final response = await http.patch(
      Uri.parse('http://51.20.3.117/api/users/patient_profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $randomtoken'
      },
      body: jsonEncode(userData),
    );
    if (response.statusCode == 200) {
      print('Details saved');
    } else {
      print(response.statusCode);
      throw Exception(response.body);
    }
  }
}

class Postpatient_Container extends StatefulWidget {
  final String staticId;
  final String Token;

  const Postpatient_Container(
      {Key? key, required this.staticId, required this.Token})
      : super(key: key);

  @override
  _Postpatient_ContainerState createState() => _Postpatient_ContainerState();
}

class _Postpatient_ContainerState extends State<Postpatient_Container> {
  bool isVerified = false;
  late Future<User> _userFuture;
  late ApiService _apiService;
  final _formKey = GlobalKey<FormState>();

  // late TextEditingController _mobileNumberController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _medicationController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _addressController;
  late TextEditingController _pincodeController;
  String _selectedsex = '';

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(token: widget.Token);
    _userFuture = _fetchUserData();

    _initControllers();
  }

  Future<User> _fetchUserData() async {
    final userData =
        await _apiService.getUserData(widget.staticId, widget.Token);
        _currentUser = User.fromJson(userData);
    _initializeTextControllers(_currentUser!);
    return _currentUser!;
  }

  void _initControllers() {
    // _mobileNumberController = TextEditingController(text: '');
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
    // _mobileNumberController.dispose();
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
        final imageUrl = await _apiService.uploadProfilePicture(
            _imageFile!, user.staticId!, widget.Token);
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
      // user.mobileNum = _mobileNumberController.text;
      user.dob = _dateOfBirthController.text;
      user.medication = _medicationController.text;
      user.weight = _weightController.text.isNotEmpty
          ? int.parse(_weightController.text)
          : null;
      user.height = _heightController.text.isNotEmpty
          ? int.parse(_heightController.text)
          : null;
      user.address = _addressController.text;
      user.age = _ageController.text.isNotEmpty
          ? int.parse(_ageController.text)
          : null;
      user.pincode = _pincodeController.text;
      user.sex = _selectedsex;

      if (_imageFile != null) {
        await _uploadProfilePicture(user);
      }
      try {
        await _apiService.saveUserDetails(user.toJson(), widget.Token);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User details saved successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
  void _calculateAndSetAge() {
    if (_dateOfBirthController.text.isNotEmpty) {
      DateTime dob =
          DateFormat('yyyy-MM-dd').parse(_dateOfBirthController.text);
      DateTime today = DateTime.now();
      int age = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }
      _ageController.text = age.toString();
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
    // _mobileNumberController.text = user.mobileNum ?? '';
    _dateOfBirthController.text = user.dob ?? '';
    _medicationController.text = user.medication ?? '';
    _weightController.text = user.weight != null ? user.weight.toString() : '';
    _heightController.text = user.height != null ? user.height.toString() : '';
    _addressController.text = user.address ?? '';
    _pincodeController.text = user.pincode ?? '';
    _ageController.text = user.age != null ? user.age.toString() : '';
    _selectedsex = user.sex ?? '';
  }

  Widget _buildUserForm(User user) {
    return Scaffold(
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
       
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // User info section (name, email, ID)
                    _buildUserInfo(user),
                    _build3TextField('Mobile Number', ''),
                    // _build3TextField(
                    // _mobileNumberController, 'Mobile number', 'Mobile number'),
                    _build4TextField(_dateOfBirthController, 'Date of Birth',
                        'Date of Birth'),
                    _buildTextField(_ageController, 'Age', 'Age'),
                    _buildGenderSelection(user),
                    _build2TextField(
                        _medicationController, 'Medication', 'Medication'),
                    _build5TextField(),
                    _build6TextField(),
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
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
        ));
  }

  Widget _build3TextField(String labelText, String hintText) {
    
    final userProvider = Provider.of<UserProvider>(context);
    
    // Accessing user data from UserProvider
    final userzz = userProvider.user;

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.all(8)),
            Container(
              padding: const EdgeInsets.all(3),
              alignment: Alignment.topLeft,
              width: 240.0,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xffcde2f5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '${userzz!.mobileNumber}',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(6)),
            Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff4268b0)),
              width: 60,
              height: 42,
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

  Widget _build5TextField() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(4)),
        Container(
          padding: EdgeInsets.all(3),
          alignment: Alignment.topLeft,
          width: 290.0,
          height: 42,
          decoration: BoxDecoration(
            color: Color(0xffcde2f5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter height';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Height (inches)',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
              floatingLabelAlignment: FloatingLabelAlignment.start,
            ),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelection(User user) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 10),
          child: Text(
            'Gender',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        Row(
          children: <Widget>[
            Radio(
              value: 'M',
              groupValue: _selectedsex,
              onChanged: (value) {
                setState(() {
                  _selectedsex = value.toString();
                });
              },
            ),
            Text(
              'Male',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Radio(
              value: 'F',
              groupValue: _selectedsex,
              onChanged: (value) {
                setState(() {
                  _selectedsex = value.toString();
                });
              },
            ),
            Text(
              'Female',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Radio(
              value: 'O',
              groupValue: _selectedsex,
              onChanged: (value) {
                setState(() {
                  _selectedsex = value.toString();
                });
              },
            ),
            Text(
              'Others',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ],
    );
  }

  Widget _build6TextField() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(4)),
        Container(
          padding: EdgeInsets.all(3),
          alignment: Alignment.topLeft,
          width: 290.0,
          height: 42,
          decoration: BoxDecoration(
            color: Color(0xffcde2f5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter weight';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
              floatingLabelAlignment: FloatingLabelAlignment.start,
            ),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, String label) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(4)),
        Container(
          padding: EdgeInsets.all(3),
          alignment: Alignment.topLeft,
          width: 290.0,
          height: 42,
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
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _build2TextField(
      TextEditingController controller, String labelText, String label) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(4)),
        Container(
          padding: EdgeInsets.all(3),
          alignment: Alignment.topLeft,
          width: 290.0,
          height: 120,
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
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _build4TextField(
      TextEditingController controller, String labelText, String label) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(4)),
        Container(
          padding: EdgeInsets.all(3),
          alignment: Alignment.topLeft,
          width: 290.0,
          height: 42,
          decoration: BoxDecoration(
            color: Color(0xffcde2f5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: label == 'Date of Birth' || label == 'Age',
            onTap: label == 'Date of Birth'
                ? () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      controller.text = formattedDate;
                      _calculateAndSetAge();
                    }
                  }
                : null,
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
              floatingLabelAlignment: FloatingLabelAlignment.start,
            ),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }
}
