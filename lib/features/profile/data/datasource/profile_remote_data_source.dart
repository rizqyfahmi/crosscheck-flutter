import 'package:crosscheck/features/profile/data/models/response/profile_response_model.dart';
import 'package:http/http.dart';

abstract class ProfileRemoteDataSource {
  
  Future<ProfileResponseModel> getProfile({required String token});

}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {

  final Client client;

  ProfileRemoteDataSourceImpl({
    required this.client
  });

  @override
  Future<ProfileResponseModel> getProfile({required String token}) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }
  
}