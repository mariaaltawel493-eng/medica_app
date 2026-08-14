import 'package:bloc/bloc.dart';
import 'package:medica_app/features/discover/clinics/data/models/specialization_model.dart';
import 'package:medica_app/features/discover/clinics/data/repos/clinics_repo.dart';

part 'specializations_event.dart';
part 'specializations_state.dart';

class SpecializationsBloc
    extends Bloc<SpecializationsEvent, SpecializationsState> {
  final ClinicsRepo clinicsRepo;

  SpecializationsBloc(this.clinicsRepo) : super(SpecializationsInitial()) {
    on<FetchSpecializationsEvent>((event, emit) async {
      emit(SpecializationsLoading());
      try {
        final specializations = await clinicsRepo.getSpecializations(
          event.clinicId,
        );
        emit(SpecializationsSuccess(specializations));
      } catch (e) {
        emit(SpecializationsError(e.toString()));
      }
    });
  }
}
