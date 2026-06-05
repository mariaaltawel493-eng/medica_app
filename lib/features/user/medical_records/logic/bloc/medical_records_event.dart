import 'dart:io';
import 'package:medica_app/features/user/medical_records/data/model/med_records_request_model.dart';

abstract class MedicalRecordsEvent {}

// جلب البيانات عند فتح الصفحة
class GetMedicalProfileEvent extends MedicalRecordsEvent {}

// تحديث البيانات النصية
class UpdateMedicalProfileEvent extends MedicalRecordsEvent {
  final MedicalRecordsRequestModel requestModel;
  UpdateMedicalProfileEvent(this.requestModel);
}

// رفع وثيقة جديدة
class UploadDocumentEvent extends MedicalRecordsEvent {
  final File file;
  final String documentType;
  final String? description;
  UploadDocumentEvent({
    required this.file,
    required this.documentType,
    this.description,
  });
}

// حذف وثيقة
class DeleteDocumentEvent extends MedicalRecordsEvent {
  final int documentId;
  DeleteDocumentEvent(this.documentId);
}
