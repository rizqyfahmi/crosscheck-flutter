import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  
  final String fullname;
  final String email;
  final String? photoUrl;
  final DateTime? dob;
  final String? address;

  const ProfileEntity({
    required this.fullname,
    required this.email,
    this.photoUrl,
    this.dob,
    this.address
  });

  @override
  List<Object?> get props => [
    fullname, email, photoUrl, dob, address
  ];
}