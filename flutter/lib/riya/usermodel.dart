class User {
  String? staticId;
  String? username;
  String? name;
  String? email;
  String? mobileNum;
  String? dob;
  String? sex;
  String? address;
  String? pincode;
  String? profilePhoto;
  String? occupation;
  String? about;
  String? qualification;
  int? authUser;
  String? medication;
  num? weight;
  num? height;

  User(
      {this.staticId,
      this.username,
      this.name,
      this.email,
      this.mobileNum,
      this.dob,
      this.sex,
      this.address,
      this.pincode,
      this.about,
      this.qualification,
      this.profilePhoto,
      this.occupation,
      this.authUser,
      this.medication,
      this.weight,
      this.height});

//   User.fromJson(Map<String, dynamic> json) {
//     staticId = json['static_id'];
//     username = json['username'];
//     name = json['name'];
//     email = json['email'];
//     mobileNum = json['mobile_num'];
//     dob = json['dob'];
//     sex = json['sex'];
//     about = json['about'];
//     qualification = json['qualification'];
//     address = json['address'];
//     pincode = json['pincode'];
//     profilePhoto = json['profile_photo'];
//     occupation = json['occupation'];
//     authUser = json['auth_user'];
//     medication = json['medication'];
//     weight = json['weight'];
//     height = json['height'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['static_id'] = this.staticId;
//     data['username'] = this.username;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['mobile_num'] = this.mobileNum;
//     data['dob'] = this.dob;
//     data['sex'] = this.sex;
//     data['address'] = this.address;
//     data['pincode'] = this.pincode;
//     data['profile_photo'] = this.profilePhoto;
//     data['occupation'] = this.occupation;
//     data['auth_user'] = this.authUser;
//     data['medication'] = this.medication;
//     data['weight'] = this.weight;
//     data['height'] = this.height;
//     data['about'] = this.about;
//     data['qualification'] = this.qualification;
//     return data;
//   }
// }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      staticId: json['staticId'],
      profilePhoto: json['profilePhoto'],
      name: json['name'],
      email: json['email'],
      mobileNum: json['mobileNum'],
      dob: json['dob'],
      medication: json['medication'],
      weight: json['weight'],
      height: json['height'],
      address: json['address'],
      pincode: json['pincode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staticId': staticId,
      'profilePhoto': profilePhoto,
      'name': name,
      'email': email,
      'mobile_num': mobileNum,
      'dob': dob,
      'medication': medication,
      'weight': weight,
      'height': height,
      'address': address,
      'pincode': pincode,
    };
  }
}
