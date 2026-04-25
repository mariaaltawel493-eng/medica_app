class PatientDataModel {
  final int id;
  final DateTime dateOfBirth;
  final String gender;
  final String? qrCodeUrl;
  final String? bloodType;
  final String? chronicDiseases;
  final String? allergies;

  PatientDataModel({
    required this.id,
    required this.dateOfBirth,
    required this.gender,
    this.qrCodeUrl,
    this.bloodType,
    this.chronicDiseases,
    this.allergies,
  });

  // تحويل من JSON إلى Object
  factory PatientDataModel.fromJson(Map<String, dynamic> json) {
    return PatientDataModel(
      id: json['id'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      gender: json['gender'],
      qrCodeUrl: json['qr_code_url'],
      bloodType: json['blood_type'],
      chronicDiseases: json['chronic_diseases'],
      allergies: json['allergies'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_of_birth': dateOfBirth
          .toIso8601String(), // تحويل التاريخ لصيغة نصية يفهمها السيرفر
      'gender': gender,
      'qr_code_url': qrCodeUrl,
      'blood_type': bloodType,
      'chronic_diseases': chronicDiseases,
      'allergies': allergies,
    };
  }
}
