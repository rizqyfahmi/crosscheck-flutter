import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  
  final String fullname;
  final String email;
  final DateTime? dob;
  final String? address;
  final String? photoUrl;

  const ProfileEntity({
    required this.fullname,
    required this.email,
    this.dob,
    this.address,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [
    fullname, email, photoUrl, dob, address
  ];
}