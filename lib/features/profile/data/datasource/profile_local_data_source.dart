import 'package:crosscheck/features/profile/data/models/data/profile_model.dart';

abstract class ProfileLocalDataSource {
  
  Future<void> setProfile(ProfileModel profileModel);

  Future<ProfileModel> getProfile();

}