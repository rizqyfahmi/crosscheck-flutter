import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationLocalDataSource {
  
  Future<void> setToken(String token);
  
}

class AuthenticationLocalDataSourceImpl implements AuthenticationLocalDataSource {

  final SharedPreferences sharedPreferences;

  AuthenticationLocalDataSourceImpl({
    required this.sharedPreferences
  });
  
  @override
  Future<void> setToken(String token) async {
    await sharedPreferences.setString("token", token);
  }

}