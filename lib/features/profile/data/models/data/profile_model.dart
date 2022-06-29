import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:hive/hive.dart';

part "profile_model.g.dart";

@HiveType(typeId: 0)
class ProfileModel extends ProfileEntity {
  
  @override
  @HiveField(0)
  String get id => super.id;

  @override
  @HiveField(1)
  String get fullname => super.fullname;

  @override
  @HiveField(2)
  String get email => super.email;

  @override
  @HiveField(3)
  DateTime? get dob => super.dob;

  @override
  @HiveField(4)
  String? get address => super.address;

  @override
  @HiveField(5)
  String? get photoUrl => super.photoUrl;

  const ProfileModel({
    required super.id,
    required super.fullname, 
    required super.email,
    super.dob,
    super.address,
    super.photoUrl
  });

  factory ProfileModel.fromJSON(Map<String, dynamic> response) {
    final isDobNull = response["dob"] == "" || response["dob"] == null;
    final isAddressNull = response["address"] == "" || response["address"] == null;
    final isPhotoUrlNull = response["photoUrl"] == "" || response["photoUrl"] == null;

    return ProfileModel(
      id: response["id"],
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