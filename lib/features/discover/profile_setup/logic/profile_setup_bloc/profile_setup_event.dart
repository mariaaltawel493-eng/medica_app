// lib/features/profile_setup/logic/profile_setup_bloc/profile_setup_event.dart

part of 'profile_setup_bloc.dart';

abstract class ProfileSetupEvent {}

// هذا الحدث يُستدعى في كل مرة يغير فيها المستخدم قيمة في الـ UI
// يقوم بتحديث الـ draftData في الـ State
class UpdateDraftDataEvent extends ProfileSetupEvent {
  final PatientDataModel updatedData;

  UpdateDraftDataEvent(this.updatedData);
}

// هذا الحدث يُستدعى فقط عند الضغط على زر "حفظ" النهائي
// يقوم بإرسال البيانات فعلياً للسيرفر عبر الـ Repository
class SubmitProfileEvent extends ProfileSetupEvent {}
