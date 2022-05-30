import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/data/models/response/authentication_response_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  
  Future<AuthenticationResponseModel> registration(RegistrationParams params);
  
}

class AuthenticationRemoteDataSourceImpl implements AuthenticationRemoteDataSource {

  final http.Client client;

  AuthenticationRemoteDataSourceImpl({
    required this.client
  });
  
  @override
  Future<AuthenticationResponseModel> registration(RegistrationParams params) {
    // TODO: implement registration
    throw UnimplementedError();
  }
  
}