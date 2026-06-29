import 'package:bloc/bloc.dart';
import 'package:medica_app/features/discover/clinics/data/models/doctor_model.dart';
import 'package:medica_app/features/discover/clinics/data/repos/clinics_repo.dart';
import 'package:meta/meta.dart';

part 'doctors_event.dart';
part 'doctors_state.dart';

class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  final ClinicsRepo clinicsRepo;

  DoctorsBloc(this.clinicsRepo) : super(DoctorsInitial()) {
    // جلب أطباء عيادة محددة بتخصص محدد
    on<FetchDoctorsEvent>((event, emit) async {
      emit(DoctorsLoading());
      try {
        final doctors = await clinicsRepo.getDoctors(
          event.clinicId,
          event.specializationId,
        );
        emit(DoctorsSuccess(doctors));
      } catch (e) {
        emit(DoctorsError(e.toString()));
      }
    });

    // جلب جميع الأطباء (للـ AllDoctorsScreen من HomeScreen)
    on<FetchAllDoctorsEvent>((event, emit) async {
      emit(DoctorsLoading());
      try {
        final doctors = await clinicsRepo.getAllDoctors();
        emit(DoctorsSuccess(doctors));
      } catch (e) {
        emit(DoctorsError(e.toString()));
      }
    });

    // بحث داخل أطباء عيادة محددة
    on<SearchDoctorsEvent>((event, emit) async {
      emit(DoctorsLoading());
      try {
        final doctors = await clinicsRepo.getDoctors(
          event.clinicId,
          event.specializationId,
          name: event.name,
        );
        emit(DoctorsSuccess(doctors));
      } catch (e) {
        emit(DoctorsError(e.toString()));
      }
    });

    // بحث في جميع الأطباء
    on<SearchAllDoctorsEvent>((event, emit) async {
      emit(DoctorsLoading());
      try {
        final doctors = await clinicsRepo.getAllDoctors(name: event.name);
        emit(DoctorsSuccess(doctors));
      } catch (e) {
        emit(DoctorsError(e.toString()));
      }
    });
  }
}
