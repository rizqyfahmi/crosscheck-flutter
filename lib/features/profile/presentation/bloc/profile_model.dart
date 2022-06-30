import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  
  final String fullname;
  final String email;
  final String formattedDob;
  final String address;
  final String photoUrl;

  const ProfileModel({
    required this.fullname,
    required this.email,
    required this.formattedDob,
    required this.address,
    required this.photoUrl
  });

  @override
  List<Object?> get props => [fullname, email, formattedDob, address, photoUrl];
  
}