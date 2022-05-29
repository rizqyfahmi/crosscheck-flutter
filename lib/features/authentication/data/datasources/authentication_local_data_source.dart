import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationLocalDataSource {
  
  Future<bool> setToken(String token);
  
}

class AuthenticationLocalDataSourceImpl implements AuthenticationLocalDataSource {

  final SharedPreferences sharedPreferences;

  AuthenticationLocalDataSourceImpl({
    required this.sharedPreferences
  });
  
  @override
  Future<bool> setToken(String token) async {
    return await sharedPreferences.setString("token", token);
  }

}