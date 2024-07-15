class Doctor {
  final String id;
  final String name;
  final String email;
  String? mobileNumber;
  String? dateOfBirth;
  String? qualification;
  String? age;
  String? about;

  String? address;

  String? profilePictureUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    this.mobileNumber,
    this.dateOfBirth,
    this.qualification,
    this.age,
    this.address,
    this.about,
      this.profilePictureUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ,
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      dateOfBirth: json['dateOfBirth'],
      qualification: json['qualification'],
      age: json['age'],
      address: json['address'],
      about: json['about'],
       profilePictureUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'dateOfBirth': dateOfBirth,
      'qualification': qualification,
      'age': age,
      'about': about,
      'address': address,
        'profilePictureUrl': profilePictureUrl,
    };
  }
}



  
     
    
