import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/features/discover/Clinics/logic/doctors_bloc/doctors_bloc.dart';
import 'package:medica_app/features/discover/Clinics/logic/hospitals_bloc/hospitals_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // لإعادة البحث تلقائياً لو غيرتِ التبويب وكانت الخانة مليانة
    _tabController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        _triggerSearch(_searchController.text);
      }
    });
  }

  // 🔥 دالة البحث التي تحدد أي بلوك نستخدم حسب التبويب
  void _triggerSearch(String query) {
    if (query.trim().isEmpty) return;

    if (_tabController.index == 0) {
      // استدعاء بحث الأطباء الشامل (تأكدي إذا كان الباراميتر اسمه name أو يُمرر مباشرة)
      // إذا كان كلاس الحدث يأخذ parameter اسمه name استبدليها بـ SearchAllDoctorsEvent(name: query)
      BlocProvider.of<DoctorsBloc>(context).add(SearchAllDoctorsEvent(query));
    } else {
      // استدعاء بحث العيادات
      BlocProvider.of<HospitalsBloc>(context).add(SearchHospitalsEvent(query));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "ابحث عن طبيب أو عيادة...".tr(),
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: _triggerSearch, // استدعاء البحث عند الكتابة
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: "الأطباء".tr()),
            Tab(text: "العيادات".tr()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 👨‍⚕️ التبويب الأول: نتائج بحث الأطباء
          BlocBuilder<DoctorsBloc, DoctorsState>(
            builder: (context, state) {
              if (state is DoctorsLoading) {
                return const Center(child: AppLoadingIndicator());
              } else if (state is DoctorsSuccess) {
                final doctors =
                    state.doctors; // تأكدي من اسم المتغير في حالة النجاح

                if (doctors.isEmpty) {
                  return Center(
                    child: Text("لا يوجد أطباء مطابقين للبحث".tr()),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return Card(
                      color: isDark
                          ? AppColors.darkscaffoldBackground
                          : Colors.white,
                      child: ListTile(
                        // استبدلي الحقول حسب الموجود في DoctorModel عندك
                        title: Text(doctor.name ?? 'بدون اسم'),
                        subtitle: Text(doctor.specialization ?? ''),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: الانتقال لتفاصيل الطبيب
                        },
                      ),
                    );
                  },
                );
              } else if (state is DoctorsError) {
                return Center(child: Text(state.message));
              }

              return Center(child: Text("اكتب اسم الطبيب للبحث".tr()));
            },
          ),

          // 🏥 التبويب الثاني: نتائج بحث العيادات
          BlocBuilder<HospitalsBloc, HospitalsState>(
            builder: (context, state) {
              if (state is HospitalsLoading) {
                return const Center(child: AppLoadingIndicator());
              } else if (state is HospitalsSuccess) {
                final clinics = state.hospitals;

                if (clinics.isEmpty) {
                  return Center(child: Text("لا توجد عيادات مطابقة".tr()));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: clinics.length,
                  itemBuilder: (context, index) {
                    final clinic = clinics[index];
                    return Card(
                      color: isDark
                          ? AppColors.darkscaffoldBackground
                          : Colors.white,
                      child: ListTile(
                        title: Text(clinic.name ?? 'بدون اسم'),
                        subtitle: Text(clinic.address ?? ''),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: الانتقال لتفاصيل العيادة
                        },
                      ),
                    );
                  },
                );
              } else if (state is HospitalsError) {
                return Center(child: Text(state.message));
              }

              return Center(child: Text("اكتب اسم العيادة للبحث".tr()));
            },
          ),
        ],
      ),
    );
  }
}
