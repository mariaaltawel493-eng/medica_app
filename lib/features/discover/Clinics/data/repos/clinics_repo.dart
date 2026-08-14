import 'package:medica_app/features/discover/clinics/data/models/doctor_details_model.dart';
import 'package:medica_app/features/discover/clinics/data/models/doctor_model.dart';
import 'package:medica_app/features/discover/clinics/data/models/hospital_model.dart';
import 'package:medica_app/features/discover/clinics/data/models/specialization_model.dart';

abstract class ClinicsRepo {
  Future<List<HospitalModel>> getHospitals();
  Future<List<HospitalModel>> searchHospitals(String query);
  Future<List<SpecializationModel>> getSpecializations(int clinicId);
  Future<List<DoctorModel>> getDoctors(
    int clinicId,
    int specializationId, {
    String? name,
  });
  Future<List<DoctorModel>> getAllDoctors({String? name});
  Future<DoctorDetailsModel> getDoctorDetails(int doctorId, int clinicId);
  Future<List<HospitalModel>> getDoctorClinics(int doctorId);


// ============================================================
// إضافات مطلوبة على clinics_repo_imp.dart (التنفيذ الفعلي)
// ضيفي هاد الميثود جوا class ClinicsRepoImp implements ClinicsRepo { ... }
// ============================================================


}
