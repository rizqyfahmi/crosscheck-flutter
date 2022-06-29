import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/profile/data/models/data/profile_model.dart';
import 'package:hive_flutter/adapters.dart';

abstract class ProfileLocalDataSource {
  
  Future<void> setProfile(ProfileModel profileModel);

  Future<ProfileModel> getProfile();

}

class ProfileLocalDdataSourceImpl implements ProfileLocalDataSource {

  final Box<ProfileModel> box;

  ProfileLocalDdataSourceImpl({
    required this.box
  });

  @override
  Future<ProfileModel> getProfile() async {
    if (!box.isOpen) {
      throw CacheException(message: Failure.localDatabase);
    }

    ProfileModel? response = box.get("currentProfile");

    if (response != null) {
      return Future.value(response);
    }

    throw CacheException(message: Failure.localDatabase);
  }

  @override
  Future<void> setProfile(ProfileModel profileModel) async {
    if (!box.isOpen) {
      throw CacheException(message: Failure.localDatabase);
    }
    
    await box.put("currentProfile", profileModel);
  }
  
}