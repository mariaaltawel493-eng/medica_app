import 'dart:io';
import 'package:medica_app/core/models/patient_data_model.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/user/medical_records/data/repos/medical_records_repo.dart';

class MedicalRecordsRepoImp implements MedicalRecordsRepo {
  final ApiService apiService;

  MedicalRecordsRepoImp(this.apiService);

  @override
  Future<PatientDataModel> getMedicalProfile() async {
    // تأكدي أن هذا الرابط مطابق تماماً للـ Routes في الباكيند
    final response = await apiService.get('profile/medical');
    return PatientDataModel.fromJson(response['data']);
  }

  @override
  Future<String> updateMedicalProfile(Map<String, dynamic> data) async {
    final response = await apiService.put('profile/medical', body: data);
    return response['message'] ?? 'Medical profile updated successfully';
  }

  @override
  Future<String> uploadDocument({
    required File file,
    required String documentType,
    String? description,
  }) async {
    final response = await apiService.postMultipart(
      endpoint: 'profile/documents',
      File: file, // تعديل الاسم ليصبح سمول ليتوافق مع متغيرات الدارت
      fileKey: 'file',
      fields: {
        'document_type': documentType,
        if (description != null) 'description': description,
      },
    );
    return response['message'] ?? 'Document uploaded successfully';
  }

  @override
  Future<String> deleteDocument(int documentId) async {
    final response = await apiService.delete('profile/documents/$documentId');
    return response['message'] ?? 'Document deleted successfully';
  }
}
