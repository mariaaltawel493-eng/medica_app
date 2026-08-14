class MedicalRecordsRequestModel {
  final String? bloodType;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  final List<String>? chronicDiseases;
  final List<String>? currentMedications;
  final List<String>? allergies;
  final String? notes;

  MedicalRecordsRequestModel({
    this.bloodType,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.chronicDiseases,
    this.allergies,
    this.notes,
    this.currentMedications,
  });

  // لتحويل الموديل إلى JSON عند إرساله في الـ API (Request Body)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (bloodType != null) data['blood_type'] = bloodType;
    if (address != null) data['address'] = address;
    if (emergencyContactName != null) {
      data['emergency_contact_name'] = emergencyContactName;
    }
    if (emergencyContactPhone != null) {
      data['emergency_contact_phone'] = emergencyContactPhone;
    }
    if (emergencyContactRelation != null) {
      data['emergency_contact_relation'] = emergencyContactRelation;
    }
    if (currentMedications != null) {
      data['current_medications'] = currentMedications;
    }
    if (chronicDiseases != null) data['chronic_diseases'] = chronicDiseases;
    if (allergies != null) data['allergies'] = allergies;
    if (notes != null) data['notes'] = notes;

    return data;
  }
}
