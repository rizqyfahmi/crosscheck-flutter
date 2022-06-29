import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  
  const ProfileModel({required super.fullname, required super.email, super.dob, super.address, super.photoUrl});

  factory ProfileModel.fromJSON(Map<String, dynamic> response) {
    final isDobNull = response["dob"] == "" || response["dob"] == null;
    final isAddressNull = response["address"] == "" || response["address"] == null;
    final isPhotoUrlNull = response["photoUrl"] == "" || response["photoUrl"] == null;

    return ProfileModel(
      fullname: response["fullname"],
      email: response["email"],
      dob: !isDobNull ? DateTime.parse(response["dob"]) : null,
      address: !isAddressNull ? response["address"] : null,
      photoUrl: !isPhotoUrlNull ? response["photoUrl"] : null
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