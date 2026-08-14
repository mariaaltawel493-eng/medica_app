import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';
import 'package:medica_app/core/networking/api_service.dart';
import 'package:meta/meta.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final ApiService apiService;
  LanguageCubit(this.apiService) : super(LanguageState(const Locale('en')));
  void ChangeLanguage(BuildContext context, String langCode) async {
    Locale newLocale = Locale(langCode);
    await context.setLocale(newLocale);
    await SharedPrefHelper.setData('user_language', langCode);
    emit(LanguageState(newLocale));
    UpdateLanguageOnServer(langCode);
  }

  Future<void> UpdateLanguageOnServer(String LangCode) async {
    try {
      String currentTheme =
          await SharedPrefHelper.getData('theme_mode') ?? 'light';
      await apiService.put(
        'profile/preferences',
        body: {'language': LangCode, 'theme': currentTheme},
      );
      print(
        'Languge & Theme Update on server lang:$LangCode,theme:$currentTheme',
      );
    } catch (e) {
      print("Error updating prefernces:$e");
    }
  }
}
