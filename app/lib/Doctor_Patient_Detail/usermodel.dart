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
  String? description;
  int? authUser;
  String? medication;
  num? weight;
  num? height;
  num? age;

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
      this.age,
      this.description,
      this.profilePhoto,
      this.occupation,
      this.authUser,
      this.medication,
      this.weight,
      this.height});

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
      about: json['about'],
      description: json['description'],
      pincode: json['pincode'],
      sex: json['sex'],
      age: json['age'],
      
    );
  }

  Map<String, dynamic> toJson() {
    if (mobileNum != null)
    return {
      'staticId': staticId,
      'profilePhoto': profilePhoto,
      'name': name,
      'email': email,
      'mobile_num': mobileNum,
      'dob': dob,
      'medication': medication,
      'description': description,
      'about': about,
      'weight': weight,
      'height': height,
      'address': address,
      'pincode': pincode,
      'sex': sex,
      'age': age,
    };
    else 
    return{
      'staicId': staticId,
      'profilePhoto': profilePhoto,
      'name': name,
      'email': email,
      'dob': dob,
      'medication': medication,
      'weight': weight,
      'height': height,
      'address': address,
      'age': age,
      'pincode': pincode,
      'sex': sex,
      'description': description,
      'about': about,
    };
  }
}
