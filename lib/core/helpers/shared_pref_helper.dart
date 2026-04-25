import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  // مفاتيح ثابتة مشان ما نغلط بكتابة اسمها كل مرة
  static const String _userTokenKey = 'user_token';
  static const String _onboardingKey = 'onboarding_seen';

  // دالة لحفظ التوكن
  static Future<void> setData(String key, dynamic value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (value is String) await sharedPreferences.setString(key, value);
    if (value is int) await sharedPreferences.setInt(key, value);
    if (value is bool) await sharedPreferences.setBool(key, value);
    if (value is double) await sharedPreferences.setDouble(key, value);
  }

  // دالة لجلب البيانات
  static dynamic getData(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }

  // دالة مخصصة لحفظ التوكن (لسهولة الاستخدام)
  static Future<void> saveUserToken(String token) async {
    await setData(_userTokenKey, token);
  }

  // دالة لجلب التوكن
  static Future<String?> getUserToken() async {
    return await getData(_userTokenKey);
  }
}
