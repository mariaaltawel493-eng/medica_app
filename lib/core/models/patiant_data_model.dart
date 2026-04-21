class PatientDataModel {
  final int id;
  final DateTime dateOfBirth;
  final String gender;
  final String qrCodeUrl;

  PatientDataModel({
    required this.id,
    required this.dateOfBirth,
    required this.gender,
    required this.qrCodeUrl,
  });

  // تحويل من JSON إلى Object
  factory PatientDataModel.fromJson(Map<String, dynamic> json) {
    return PatientDataModel(
      id: json['id'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      gender: json['gender'],
      qrCodeUrl: json['qr_code_url'],
    );
  }
}
