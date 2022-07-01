import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_event.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_model.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final GetProfileUsecase getProfileUsecase;
  
  ProfileBloc({
    required this.getProfileUsecase
  }) : super(const ProfileInit()) {
    on<ProfileGetData>((event, emit) async {
      emit(ProfileLoading(model: state.model));

      // await Future.delayed(const Duration(seconds: 5));
      // emit(ProfileGeneralError(model: state.model, message: "Hello"));
      final response = await getProfileUsecase(NoParam());
      response.fold(
        (error) {
          emit(ProfileGeneralError(model: state.model, message: error.message));
        },
        (result) {
          final model = ProfileModel(
            fullname: result.fullname, 
            email: result.email, 
            formattedDob: result.dob == null ? "-" : "${result.dob?.day}-${result.dob?.month.toString().padLeft(2, "0")}-${result.dob?.year}", 
            address: result.address ?? "-", 
            photoUrl: result.photoUrl ?? "https://via.placeholder.com/60x60/F24B59/F24B59?text=."
          );

          emit(ProfileLoaded(model: model));
        }
      );
    });
    on<ProfileResetGeneralError>((event, emit) {
      emit(ProfileNoGeneralError(model: state.model));
    });
  }

}