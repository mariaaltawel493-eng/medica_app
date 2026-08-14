import 'package:medica_app/features/discover/Home/data/models/banner_model.dart';
import 'package:medica_app/features/discover/Home/data/models/topclinic_model.dart';
import 'package:medica_app/features/discover/Home/data/models/topdoctor_model.dart';

abstract class HomeRepo {
  // دالة لجلب الإعلانات والمقالات المدمجة في البانر
  Future<List<BannerModel>> getBanners();

  // دالة لجلب العيادات الأعلى تقييماً مع إمكانية تحديد الـ limit
  Future<List<TopClinicModel>> getTopClinics({int? limit});

  // دالة لجلب الأطباء الأعلى تقييماً مع إمكانية تحديد الـ limit
  Future<List<TopDoctorModel>> getTopDoctors({int? limit});
}
