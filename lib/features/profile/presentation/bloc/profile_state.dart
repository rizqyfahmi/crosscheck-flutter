import 'package:crosscheck/features/profile/presentation/bloc/profile_model.dart';
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  
  final ProfileModel model;

  const ProfileState({
    required this.model
  });

  @override
  List<Object?> get props => [model];
  
}

class ProfileInit extends ProfileState {
  const ProfileInit() : super(model: const ProfileModel(fullname: "-", email: "-", formattedDob: "-", address: "-", photoUrl: "https://via.placeholder.com/60x60/F24B59/F24B59?text=."));
}

class ProfileLoading extends ProfileState {
  const ProfileLoading({required super.model});
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required super.model});
}

class ProfileGeneralError extends ProfileState {
  final String message;

  const ProfileGeneralError({required super.model, required this.message});

  @override
  List<Object?> get props => [super.props, message];
}

class ProfileNoGeneralError extends ProfileState {
  const ProfileNoGeneralError({required super.model});
}
