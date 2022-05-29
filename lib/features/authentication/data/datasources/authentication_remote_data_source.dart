import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/data/models/response/authentication_response_model.dart';

abstract class AuthenticationRemoteDataSource {
  
  Future<AuthenticationResponseModel> registration(RegistrationParams params);
  
}

class AuthenticationRemoteDataSourceImpl implements AuthenticationRemoteDataSource {
  
  @override
  Future<AuthenticationResponseModel> registration(RegistrationParams params) {
    // TODO: implement registration
    throw UnimplementedError();
  }
  
}