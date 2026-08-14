import 'dart:io';

import 'package:medica_app/core/models/patient_data_model.dart';

abstract class MedicalRecordsRepo {
  // 1. جلب البيانات الطبية كاملة
  Future<PatientDataModel> getMedicalProfile();

  // 2. تحديث البيانات النصية (فصيلة الدم، الحساسية، إلخ)
  Future<String> updateMedicalProfile(Map<String, dynamic> data);

  // 3. رفع وثيقة جديدة (أشعة، تحاليل)
  Future<String> uploadDocument({
    required File file,
    required String documentType,
    String? description,
  });

  // 4. حذف وثيقة
  Future<String> deleteDocument(int documentId);
}
