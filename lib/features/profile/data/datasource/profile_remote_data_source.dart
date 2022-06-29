import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
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
  Future<ProfileResponseModel> getProfile({required String token}) async {
    final uri = Uri.parse("https://localhost:8080/profile");
    final headers = {'Content-Type': 'application/json', "Authorization": token};
    final response = await client.post(uri, headers: headers);
    
    final body = json.decode(response.body);

    if (response.statusCode == 200) {
      return ProfileResponseModel.fromJSON(body);
    }

    throw ServerException(message: body["message"]);
  }
  
}