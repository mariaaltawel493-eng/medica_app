import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart'; // أضفنا استيراد الـ GetIt
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/features/discover/Clinics/UI/pages/doctors_screen.dart';
import 'package:medica_app/features/discover/clinics/UI/widgets/specialization_card.dart';
import 'package:medica_app/features/discover/clinics/logic/specializations_bloc/specializations_bloc.dart';

class SpecializationsScreen extends StatefulWidget {
  final int hospitalId;
  const SpecializationsScreen({super.key, required this.hospitalId});

  @override
  State<SpecializationsScreen> createState() => _SpecializationsScreenState();
}

class _SpecializationsScreenState extends State<SpecializationsScreen> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    // قمنا بإلغاء جلب البيانات من هنا لأن الـ Provider في الأسفل سيتولى المهمة فوراً عند الإنشاء
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // نقوم بتوفير الـ Bloc للشاشة وطلب البيانات فوراً لنفس النسخة
    return BlocProvider<SpecializationsBloc>(
      create: (context) =>
          GetIt.I<SpecializationsBloc>()
            ..add(FetchSpecializationsEvent(widget.hospitalId)),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkscaffoldBackground
            : AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.darkscaffoldBackground
              : AppColors.scaffoldBackground,
          elevation: 0,
          iconTheme: IconThemeData(
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
          ),
          title: Text(
            'specializations.title'.tr(),
            style: TextStyle(
              color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
            ),
          ),
        ),
        body: BlocConsumer<SpecializationsBloc, SpecializationsState>(
          listener: (context, state) {
            if (state is SpecializationsError) {
              print("spetialziat:${state.message}");
              String errorKey;
              if (state.message.contains('no_internet') ||
                  state.message.contains('Network') ||
                  state.message.contains('connection')) {
                errorKey = 'errors.no_internet';
              } else {
                errorKey = 'errors.unknown';
              }
              Appsnackbar.showError(context, errorKey.tr());
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is SpecializationsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is SpecializationsError) {
                          return const SizedBox();
                        }
                        if (state is SpecializationsSuccess) {
                          if (state.specializations.isEmpty) {
                            return Center(
                              child: Text(
                                'specializations.empty'.tr(),
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darktextPrimary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: state.specializations.length,
                            itemBuilder: (context, index) {
                              final specialization =
                                  state.specializations[index];
                              return SpecializationCard(
                                title: specialization.name,
                                isSelected: selectedIndex == index,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedIndex == -1) return;
                        if (state is SpecializationsSuccess) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DoctorsScreen(
                                specializationId:
                                    state.specializations[selectedIndex].id,
                                specializationName:
                                    state.specializations[selectedIndex].name,
                                clinicId: widget.hospitalId,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'specializations.confirm'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
