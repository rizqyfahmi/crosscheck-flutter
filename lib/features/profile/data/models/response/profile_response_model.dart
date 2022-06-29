import 'package:crosscheck/core/response/response.dart';
import 'package:crosscheck/features/profile/data/models/data/profile_model.dart';

class ProfileResponseModel extends Response {
  
  const ProfileResponseModel({
    required super.message,
    required super.data
  });

  factory ProfileResponseModel.fromJSON(Map<String, dynamic> response) {
    return ProfileResponseModel(
      message: response["message"], 
      data: ProfileModel.fromJSON(response["data"])
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "message": message,
      "data": (data as ProfileModel).toJSON()
    };
  }

  ProfileModel get profileModel => (data as ProfileModel); 
  
}