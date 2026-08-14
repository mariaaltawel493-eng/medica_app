import 'package:bloc/bloc.dart';
import 'package:medica_app/features/discover/clinics/data/models/doctor_details_model.dart';
import 'package:medica_app/features/discover/clinics/data/repos/clinics_repo.dart';

part 'doctor_details_event.dart';
part 'doctor_details_state.dart';

class DoctorDetailsBloc extends Bloc<DoctorDetailsEvent, DoctorDetailsState> {
  final ClinicsRepo clinicsRepo;

  DoctorDetailsBloc(this.clinicsRepo) : super(DoctorDetailsInitial()) {
    on<FetchDoctorDetailsEvent>((event, emit) async {
      emit(DoctorDetailsLoading());
      try {
        final doctor = await clinicsRepo.getDoctorDetails(
          event.doctorId,
          event.clinicId,
        );
        emit(DoctorDetailsSuccess(doctor));
      } catch (e) {
        emit(DoctorDetailsError(e.toString()));
      }
    });
  }
}
