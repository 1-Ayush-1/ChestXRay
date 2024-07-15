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
