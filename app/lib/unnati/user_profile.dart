class UserProfile {
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
  String? medication;
  double? weight;
  double? height;

  UserProfile(
      {this.staticId,
      this.username,
      this.name,
      this.email,
      this.mobileNum,
      this.dob,
      this.sex,
      this.address,
      this.pincode,
      this.profilePhoto,
      this.occupation,
      this.medication,
      this.weight,
      this.height});

  UserProfile.fromJson(Map<String, dynamic> json) {
    staticId = json['static_id'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    mobileNum = json['mobile_num'];
    dob = json['dob'];
    sex = json['sex'];
    address = json['address'];
    pincode = json['pincode'];
    profilePhoto = json['profile_photo'];
    occupation = json['occupation'];
    medication = json['medication'];
    weight = json['weight'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['static_id'] = this.staticId;
    data['username'] = this.username;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_num'] = this.mobileNum;
    data['dob'] = this.dob;
    data['sex'] = this.sex;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['profile_photo'] = this.profilePhoto;
    data['occupation'] = this.occupation;
    data['medication'] = this.medication;
    data['weight'] = this.weight;
    data['height'] = this.height;
    return data;
  }
}