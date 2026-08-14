import 'package:medica_app/core/models/patient_data_model.dart';

enum MedicalRecordsStatus { initial, loading, success, error }

enum ActionStatus { initial, loading, success, error }

class MedicalRecordsState {
  /// حالة جلب الملف الطبي (Get)
  final MedicalRecordsStatus profileStatus;

  /// حالة عمليات التعديل / الرفع / الحذف (Action)
  final ActionStatus actionStatus;

  /// البيانات الطبية للمريض — محتفظ بها دائماً لمنع اختفاء الواجهة أثناء الـ Loading
  final PatientDataModel? patientData;

  /// رسالة الخطأ — null تعني لا يوجد خطأ
  final String? errorMessage;

  /// رسالة النجاح — null تعني لا توجد رسالة
  final String? successMessage;

  // 💡 المتغير الجديد تم إضافته هنا لتتبع المستند الجاري حذفه حالياً
  final int? deletingDocumentId;

  const MedicalRecordsState({
    this.profileStatus = MedicalRecordsStatus.initial,
    this.actionStatus = ActionStatus.initial,
    this.patientData,
    this.errorMessage,
    this.successMessage,
    this.deletingDocumentId, // 💡 أضفناه هنا في الـ Constructor
  });

  MedicalRecordsState copyWith({
    MedicalRecordsStatus? profileStatus,
    ActionStatus? actionStatus,
    PatientDataModel? patientData,
    String? errorMessage,
    String? successMessage,
    int? deletingDocumentId, // 💡 أضفناه هنا في استقبال دالة الـ copyWith
    // ── أعلام التصفية ──
    bool clearActionStatus = false,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return MedicalRecordsState(
      profileStatus: profileStatus ?? this.profileStatus,
      // إذا طُلب التصفية نُعيد للـ initial، وإلا نُبقي القيمة الجديدة أو القديمة
      actionStatus: clearActionStatus
          ? ActionStatus.initial
          : (actionStatus ?? this.actionStatus),
      // البيانات لا تُمحى أبداً إلا عند تمرير null صراحةً
      patientData: patientData ?? this.patientData,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),

      // 💡 هنا نمرر المتغير الجديد (إذا تمررت قيمة جديدة نأخذها، وإلا نترك القيمة القديمة)
      deletingDocumentId: deletingDocumentId ?? this.deletingDocumentId,
    );
  }

  @override
  String toString() {
    return 'MedicalRecordsState('
        'profileStatus: $profileStatus, '
        'actionStatus: $actionStatus, '
        'hasPatient: ${patientData != null}, '
        'errorMessage: $errorMessage, '
        'successMessage: $successMessage, '
        'deletingDocumentId: $deletingDocumentId' // 💡 أضفناه للطباعة والـ Debugging
        ')';
  }
}
