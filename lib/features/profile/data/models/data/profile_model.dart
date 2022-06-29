import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  
  const ProfileModel({required super.fullname, required super.email, super.dob, super.address, super.photoUrl});

  factory ProfileModel.fromJSON(Map<String, dynamic> response) {
    return ProfileModel(
      fullname: response["fullname"],
      email: response["email"],
      dob: response["dob"],
      address: response["address"],
      photoUrl: response["photoUrl"]
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "fullname": fullname,
      "email": email,
      "dob": dob,
      "address": address,
      "photoUrl": photoUrl
    };
  }
}