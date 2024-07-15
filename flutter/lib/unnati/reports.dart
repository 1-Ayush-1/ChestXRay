class UserReport {
  String? staticId;
  String? originalImage;
  String? aiText;
  String? aiImage;
  String? dateAdded;
  String? doctorComments;
  String? patient;
  String? doctor;
  UserReport({
    this.staticId,
    this.originalImage,
    this.aiText,
    this.aiImage,
    this.dateAdded,
    this.doctorComments,
    this.patient,
    this.doctor
  });

  UserReport.fromJson(Map<String, dynamic> json) {
    staticId = json['static_id'];
    originalImage = json['original_image'];
    aiText = json['ai_text'];
    aiImage = json['ai_image'];
    dateAdded = json['date_added'];
    doctorComments = json['doctor_comments'];
    patient = json['patient'];
    doctor = json['doctor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['static_id'] = this.staticId;
    data['original_image'] = this.originalImage;
    data['ai_text'] = this.aiText;
    data['ai_image'] = this.aiImage;
    data['date_added'] = this.dateAdded;
    data['doctor_comments'] = this.doctorComments;
    data['patient'] = this.patient;
    data['doctor'] = this.doctor;
    return data;
  }
}
