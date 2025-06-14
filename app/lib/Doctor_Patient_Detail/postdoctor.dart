import 'package:check/Doctor_Patient_Detail/usermodel.dart';
import 'package:check/Doctor_Patient_Detail/usermodel.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:check/User_Verification/user_provider.dart';
import 'package:provider/provider.dart';

class ApiService {
 final String baseUrl = 'http://51.20.3.117/api/';
 final String? token;
 ApiService({required this.token});

 Future<Map<String, dynamic>> getUserData(
 String staticId, String randomtoken) async {
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
 'PATCH', Uri.parse('http://51.20.3.117/api/users/doctor_profile/'));
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
 /*

{staicId: null, profilePhoto: null, name: , email: , dob: , medication: , 
 weight: null, height: null, address: , age: null, pincode: , sex: }


 */

 Future<void> saveUserDetails(
 Map<String, dynamic> userData, String randomtoken) async {
 userData
 .removeWhere((key, value) => value == null || value.toString().isEmpty);

 print("Cleaned user data: $userData");

 var request = http.MultipartRequest(
 'PATCH',
 Uri.parse('http://51.20.3.117/api/users/doctor_profile/'),
 );

 // Set headers
 request.headers['Authorization'] = 'Token $randomtoken';

 // Add fields to the request
 userData.forEach((key, value) {
 request.fields[key] = value.toString();
 });

 // Send the request
 var response = await request.send();

 // Handle response
 try {
 if (response.statusCode == 200) {
 final responseData = await response.stream.toBytes();
 final responseString = String.fromCharCodes(responseData);
 final jsonData = json.decode(responseString);
 print('Details saved: $jsonData');
 } else {
 final responseData = await response.stream.toBytes();
 final responseString = String.fromCharCodes(responseData);
 print(
 'Failed to save user details. Status code: ${response.statusCode}');
 print('Response body: $responseString');
 throw Exception(
 'Failed to save user details. Status code: ${response.statusCode}. Response: $responseString');
 }
 } catch (e) {
 print('Exception occurred: $e');
 throw Exception('Failed to save user details: $e');
 }
 }
}

class Postdoctor_Container extends StatefulWidget {
 final String staticId;
 final String Token;

 const Postdoctor_Container(
 {Key? key, required this.staticId, required this.Token})
 : super(key: key);

 @override
 _Postdoctor_ContainerState createState() => _Postdoctor_ContainerState();
}

class _Postdoctor_ContainerState extends State<Postdoctor_Container> {
 bool isVerified = false;
 bool _formSubmitted = false;
 late Future<User> _userFuture;
 late ApiService _apiService;
 final _formKey = GlobalKey<FormState>();

 // late TextEditingController _mobileNumberController;
 late TextEditingController _dateOfBirthController;
 late TextEditingController _descriptionController;
 late TextEditingController _ageController;
 late TextEditingController _aboutController;
 late TextEditingController _addressController;
 String _selectedsex = '';

 File? _imageFile;
 final ImagePicker _picker = ImagePicker();
 User? _currentUser;
 //token to Token
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
 _descriptionController = TextEditingController(text: '');
 _ageController = TextEditingController(text: '');
 _aboutController = TextEditingController(text: '');
 _addressController = TextEditingController(text: '');
 }

 @override
 void dispose() {
 // _mobileNumberController.dispose();
 _dateOfBirthController.dispose();
 _descriptionController.dispose();
 _ageController.dispose();
 _aboutController.dispose();
 _addressController.dispose();

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
 user.description = _descriptionController.text;

 user.address = _addressController.text;
 user.about = _aboutController.text;
 user.sex = _selectedsex;
 user.age = _ageController.text.isNotEmpty
 ? int.parse(_ageController.text)
 : null;

 if (_imageFile != null) {
 await _uploadProfilePicture(user);
 }

 print("Data being sent to API: ${user.toJson()}");
 try {
 await _apiService.saveUserDetails(user.toJson(), widget.Token);

 setState(() {
 _currentUser = user;
 _formSubmitted = true;
 // _initializeTextControllers(
 // _currentUser!); // Update the current user with the saved data
 });
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(content: Text('User details saved successfully')),
 );
 } catch (e) {
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text('Failed to save user details: ${e.toString()}')),
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
 return _formSubmitted ? _buildUserForm(user) : _buildUserForm(user);
 } else {
 return Text('No user data available');
 }
 },
 );
 }

 void _initializeTextControllers(User user) {
 // _mobileNumberController.text = user.mobileNum ?? '';
 _dateOfBirthController.text = user.dob ?? '';
 _descriptionController.text = user.description ?? '';
 _addressController.text = user.address ?? '';
 _aboutController.text = user.about ?? '';
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
 // GButton(icon: Icons.logout),
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
 _build2TextField(_descriptionController, 'description',
 'Qualification'),

 _buildTextField(_addressController, 'Address', 'Address'),
 _build2TextField(_aboutController, 'About', 'About'),

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
 onPressed: () async {
 await _saveUserDetails(user);
 if (_formSubmitted) {
 // Refresh the page to show user details
 setState(() {});
 }
 },

 // onPressed: () => _saveUserDetails(user),
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
 Navigator.pushNamed(
 context, 'patient_search_screen/');
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
 final userzz = userProvider.user;

 return Column(
 children: [
 const SizedBox(height: 10),
 Row(
 mainAxisAlignment: MainAxisAlignment.center,
 crossAxisAlignment:
 CrossAxisAlignment.start, // Added crossAxisAlignment
 children: [
 const Padding(padding: EdgeInsets.all(8)),

 // Wrapped the container with Expanded to take available space
 Container(
 padding: const EdgeInsets.all(3),
 alignment: Alignment.topLeft,
 height: 42,
 width: 240,
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

 const SizedBox(width: 6), // Adjusted padding to SizedBox
 Container(
 alignment: Alignment.center,
 decoration: BoxDecoration(
 borderRadius: BorderRadius.circular(8),
 color: const Color(0xff4268b0),
 ),
 width: 60,
 height: 42, // Increased height to match TextField
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
 final userProvider = Provider.of<UserProvider>(context);
 final userzz = userProvider.user;

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
 userzz!.name,
 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
 ),
 SizedBox(height: 5),
 Text(userzz.email),
 // Text("ok"),
 // SizedBox(height: 5),
 // Text(user.staticId!),
 ],
 ),
 ],
 ),
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