part of 'home_bloc_bloc.dart';

@immutable
sealed class HomeBlocEvent {}

// الحدث الرئيسي لجلب بيانات الصفحة الرئيسية بالكامل
class FetchHomeDataEvent extends HomeBlocEvent {}
