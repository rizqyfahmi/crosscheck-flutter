import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';

abstract class AuthenticationLocalDataSource {
  
  Future<void> setToken(String token);
  
}