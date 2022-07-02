import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  
  final String id;
  final String fullname;
  final String email;
  final DateTime? dob;
  final String? address;
  final String? photoUrl;

  const ProfileEntity({
    required this.id,
    required this.fullname,
    required this.email,
    this.dob,
    this.address,
    this.photoUrl,
  });

  ProfileEntity copyWith(
    String? id,
    String? fullname,
    String? email,
    DateTime? dob,
    String? address,
    String? photoUrl
  ) {
    return ProfileEntity(
      id: id ?? this.id, 
      fullname: fullname ?? this.fullname, 
      email: email ?? this.email,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl
    );
  }

  @override
  List<Object?> get props => [
    id, fullname, email, photoUrl, dob, address
  ];
}