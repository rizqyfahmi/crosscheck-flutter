import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';

abstract class AuthenticationRemoteDataSource {
  
  Future<AuthenticationModel> registration();
  
}