import 'package:crosscheck/features/profile/data/models/data/profile_model.dart';
import 'package:crosscheck/features/profile/data/models/response/profile_response_model.dart';

abstract class ProfileRemoteDataSource {
  
  Future<ProfileResponseModel> getProfile({required String token});

}