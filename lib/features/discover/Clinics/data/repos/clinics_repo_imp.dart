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
}
