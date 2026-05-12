import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:meta/meta.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ApiService apiService;
  // هون بالـ super منحدد الحالة الأولى
  ThemeCubit(this.apiService) : super(ThemeState(ThemeMode.system));

  void loadTheme() async {
    final themeString = await SharedPrefHelper.getData('theme_mode');
    if (themeString == 'light') {
      emit(ThemeState(ThemeMode.light));
    } else if (themeString == 'dark') {
      emit(ThemeState(ThemeMode.dark));
    } else {
      emit(ThemeState(ThemeMode.system));
    }
  }

  void toggleTheme(bool isDark) async {
    // 1. التحديث المحلي (مشان السرعة)
    String themeValue = isDark ? 'dark' : 'light';
    emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
    await SharedPrefHelper.setData('theme_mode', themeValue);

    // 2. تحديث السيرفر
    updateThemeOnServer(themeValue);
  }

  // دالة خاصة لإرسال الطلب للسيرفر مندون ما يعلق الـ UI
  void updateThemeOnServer(String themeValue) async {
    try {
      String currentLang =
          await SharedPrefHelper.getData('user_language') ?? 'en';
      await apiService.put(
        'profile/preferences',
        body: {'theme': themeValue, 'language': currentLang},
      );
      print(
        "Theme updated successfully on server theme:$themeValue,lang:$currentLang",
      );
    } catch (e) {
      // لا نظهر خطأ للمستخدم هنا لأن الثيم محلياً يعمل
      print("Error updating theme on server: $e");
    }
  }
}
