import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';

abstract class AuthenticationRemoteDataSource {
  
  Future<AuthenticationModel> registration(RegistrationParams params);
  
}