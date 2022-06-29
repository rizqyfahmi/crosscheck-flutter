import 'package:crosscheck/features/profile/data/models/data/profile_model.dart';

abstract class ProfileRemoteDataSource {
  
  Future<ProfileModel> getProfile({required String token});

}