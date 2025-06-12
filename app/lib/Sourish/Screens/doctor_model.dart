// lib/models/doctor_model.dart
class Doctor {
  final String staticId;
  final int authUser;
  final String name;
  final String email;
  final String mobileNum;
  final DateTime dob;
  final String sex;
  final String address;
  final String pincode;
  final int age;
  final String about;
  final String description;
  final double rating;
  final String? profilePhotoUrl;

  Doctor({
    required this.staticId,
    required this.authUser,
    required this.name,
    required this.email,
    required this.mobileNum,
    required this.dob,
    required this.sex,
    required this.address,
    required this.pincode,
    required this.age,
    required this.about,
    required this.description,
    required this.rating,
    this.profilePhotoUrl,
  });

factory Doctor.fromJson(Map<String, dynamic> json) {
  return Doctor(
    staticId: json['static_id'],
    authUser: json['auth_user'],
    name: json['name'],
    email: json['email'],
    mobileNum: json['mobile_num'],
    dob: DateTime.parse(json['dob']),
    sex: json['sex'],
    address: json['address'],
    pincode: json['pincode'],
    age: json['age'],
    about: json['about'],
    description: json['description'],
    rating: json['rating'].toDouble(),
    profilePhotoUrl: json['profile_photo'],
  );
}
  
}
/*


Future<void> sendtodoctor(BuildContext context, String image_static_id, String doctor_static_id, String random) async {
  final response = await http.patch(
    Uri.parse('http://51.20.3.117/api/images/post_images_to_doctor/'),
    headers: {
      'Content-Type': 'application/json',
        // 'Accept': 'application/x-www-form-urlencoded',
      'Authorization': 'Token $random'
    },
    body: jsonEncode({
      'image_static_id' : image_static_id,
      'doctor_static_id': doctor_static_id,
    }),
  );


  print(response.body);
  if (response.statusCode == 200) {
    // print('badiya hai');
    print('Details saved');
    Navigator.pushNamed(context, 'post_doctor/');
  } 
  else if (response.statusCode == 400) {
    // Show a snackbar with the message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User with this mobile number already exists. Please verify with another number.'),
      ),
    ).closed.then((reason) {
      // After Snackbar is closed, navigate to 'Postpatient_Container/'
      Navigator.pushNamed(context, 'patient_profile/');
    });
  } else {
    // Handle other status codes or throw an exception as needed
    print(response.statusCode);
    print('Failed to save user details: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to save user details: ${response.statusCode}');
  }
  // Navigator.pushNamed(context, 'patient_profile/');
}

*/