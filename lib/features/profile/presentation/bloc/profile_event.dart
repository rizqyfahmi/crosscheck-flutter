import 'package:equatable/equatable.dart';

class ProfileEvent extends Equatable {
  
  const ProfileEvent();

  @override
  List<Object?> get props => [];

}

class ProfileGetData extends ProfileEvent {}
class ProfileResetGeneralError extends ProfileEvent {}