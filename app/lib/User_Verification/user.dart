class User {
  final String token; 
  final String staticId; 
  final String username; 
  final String name; 
  final String email; 
  final String mobileNumber;
  final DateTime? dob; // we are sure these are not null
  final String sex;
  final String? address;
  final String pincode;
  final String? profilePhoto;
  final String? occupation;
  final int authUser;

  User({
    required this.token,
    required this.staticId,
    required this.username,
    required this.name,
    required this.email,
    required this.mobileNumber,
    this.dob,
    required this.sex,
    this.address,
    required this.pincode,
    this.profilePhoto,
    this.occupation,
    required this.authUser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      staticId: json['user']['static_id'],
      username: json['user']['username'],
      name: json['user']['name'] ?? '',
      email: json['user']['email'],
      mobileNumber: json['user']['mobile_num'],
      dob: json['user']['dob'] != null ? DateTime.parse(json['user']['dob']) : null,
      sex: json['user']['sex'] ?? '',
      address: json['user']['address'],
      pincode: json['user']['pincode'] ?? '',
      profilePhoto: json['user']['profile_photo'],
      occupation: json['user']['occupation'],
      authUser: json['user']['auth_user'],
    );
  }
}
