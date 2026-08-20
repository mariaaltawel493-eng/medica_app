import 'package:bloc/bloc.dart';
import 'package:medica_app/features/discover/clinics/data/models/hospital_model.dart';
import 'package:medica_app/features/discover/clinics/data/repos/clinics_repo.dart';

part 'hospitals_event.dart';
part 'hospitals_state.dart';

class HospitalsBloc extends Bloc<HospitalsEvent, HospitalsState> {
  final ClinicsRepo clinicsRepo;

  HospitalsBloc(this.clinicsRepo) : super(HospitalsInitial()) {
    on<FetchHospitalsEvent>((event, emit) async {
      emit(HospitalsLoading());
      try {
        final hospitals = await clinicsRepo.getHospitals();
        emit(HospitalsSuccess(hospitals));
      } catch (e) {
        emit(HospitalsError(e.toString()));
      }
    });

<<<<<<< HEAD
=======
    // ✅ 2. التعديل الجديد: جلب عيادات دكتور معين
    on<FetchDoctorClinicsEvent>((event, emit) async {
      emit(HospitalsLoading());
      try {
        // هون عم نستدعي الدالة اللي بتجيب عيادات الدكتور من الريبو
        final hospitals = await clinicsRepo.getDoctorClinics(event.doctorId);
        emit(HospitalsSuccess(hospitals));
      } catch (e) {
        emit(HospitalsError(e.toString()));
      }
    });
>>>>>>> Sedra
    on<SearchHospitalsEvent>((event, emit) async {
      emit(HospitalsLoading());
      try {
        final hospitals = await clinicsRepo.searchHospitals(event.query);
        emit(HospitalsSuccess(hospitals));
      } catch (e) {
        emit(HospitalsError(e.toString()));
      }
    });
  }
}
