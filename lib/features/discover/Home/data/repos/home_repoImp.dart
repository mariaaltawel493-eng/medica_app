import 'package:medica_app/core/networking/api_service.dart';
import 'package:medica_app/features/discover/Home/data/models/banner_model.dart';
import 'package:medica_app/features/discover/Home/data/models/topclinic_model.dart';
import 'package:medica_app/features/discover/Home/data/models/topdoctor_model.dart';
import 'package:medica_app/features/discover/Home/data/repos/home_repo.dart';

class HomeRepoimp implements HomeRepo {
  final ApiService apiService;

  HomeRepoimp(this.apiService);

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await apiService.get("banner");

      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TopClinicModel>> getTopClinics({int? limit}) async {
    try {
      // بناء الـ endpoint مع الـ limit إن وُجد (مثلاً clinics?limit=2)
      String endpoint = "clinics";
      if (limit != null) {
        endpoint += "?limit=$limit";
      }

      final response = await apiService.get(endpoint);
      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => TopClinicModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TopDoctorModel>> getTopDoctors({int? limit}) async {
    try {
      String endpoint = "doctors";
      if (limit != null) {
        endpoint += "?limit=$limit";
      }

      final response = await apiService.get(endpoint);
      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => TopDoctorModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
