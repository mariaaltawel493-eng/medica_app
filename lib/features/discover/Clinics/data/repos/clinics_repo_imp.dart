import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/discover/clinics/data/models/doctor_details_model.dart';
import 'package:medica_app/features/discover/clinics/data/models/doctor_model.dart';
import 'package:medica_app/features/discover/clinics/data/models/hospital_model.dart';
import 'package:medica_app/features/discover/clinics/data/models/specialization_model.dart';
import 'package:medica_app/features/discover/clinics/data/repos/clinics_repo.dart';

class ClinicsRepoImp implements ClinicsRepo {
  final ApiService apiService;
  ClinicsRepoImp(this.apiService);

  @override
  Future<List<HospitalModel>> getHospitals() async {
    try {
      final response = await apiService.get('clinics');
      final List data = response['data'];
      return data.map((e) => HospitalModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HospitalModel>> searchHospitals(String query) async {
    try {
      final response = await apiService.get('clinics?q=$query');
      final List data = response['data'];
      return data.map((e) => HospitalModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SpecializationModel>> getSpecializations(int clinicId) async {
    try {
      final response = await apiService.get('clinics/$clinicId');
      final List specializations = response['data']['specializations'];
      return specializations
          .map((e) => SpecializationModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DoctorModel>> getDoctors(
    int clinicId,
    int specializationId, {
    String? name,
  }) async {
    try {
      String endpoint =
          'clinics/$clinicId/doctors?specialization_id=$specializationId';
      if (name != null && name.isNotEmpty) {
        endpoint += '&name=$name';
      }
      final response = await apiService.get(endpoint);
      final List data = response['data'];
      return data.map((e) => DoctorModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DoctorModel>> getAllDoctors({String? name}) async {
    try {
      String endpoint = 'doctors';
      if (name != null && name.isNotEmpty) {
        endpoint += '?name=$name';
      }
      final response = await apiService.get(endpoint);
      final List data = response['data'];
      return data.map((e) => DoctorModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DoctorDetailsModel> getDoctorDetails(
    int doctorId,
    int clinicId,
  ) async {
    try {
      final response = await apiService.get(
        'doctors/$doctorId?clinic_id=$clinicId',
      );
      return DoctorDetailsModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }
  // ============================================================
  // عدّلي ميثود getDoctorClinics بملف clinics_repo_imp.dart لتصير هيك
  // بالضبط (استبدلي القديمة كاملة):
  // ============================================================

  @override
  Future<List<HospitalModel>> getDoctorClinics(int doctorId) async {
    try {
      // ⚠️ بدون clinic_id قصداً — هيك بيرجعلنا قائمة كل عيادات الدكتور
      final response = await apiService.get('doctors/$doctorId');

      final data = response is Map ? response['data'] : null;
      final clinicsList = data is Map ? data['clinics'] : null;

      if (clinicsList is! List) return [];

      // ✅ تحويل يدوي — لأنه شكل كل عنصر هون مختلف عن HospitalModel.fromJson
      // العادية (clinic_id بدل id، clinic_name بدل name...) فمش منقدر
      // نستخدم HospitalModel.fromJson() القياسية هون مباشرة
      return clinicsList.map<HospitalModel>((e) {
        final map = e as Map<String, dynamic>;
        return HospitalModel(
          id: _parseInt(map['clinic_id']),
          name: map['clinic_name']?.toString() ?? '',
          address: map['clinic_address']?.toString() ?? '',
          phone: '', // ما إلها قيمة بهاد الـ endpoint
          logo: null, // ما إلها قيمة بهاد الـ endpoint
          specializationsCount: 0, // ما إلها قيمة بهاد الـ endpoint
          averageRating: 0.0, // ما إلها قيمة بهاد الـ endpoint
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // ✅ هيلبر بسيطة لتحويل آمن لأي قيمة إلى int (بدون ما تنهار لو null)
  int _parseInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    return int.tryParse(val.toString()) ?? 0;
  }
}
