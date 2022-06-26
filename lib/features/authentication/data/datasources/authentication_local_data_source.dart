import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationLocalDataSource {
  
  Future<void> setToken(AuthenticationModel model);

  Future<AuthenticationModel> getToken();
  
}

class AuthenticationLocalDataSourceImpl implements AuthenticationLocalDataSource {

  final SharedPreferences sharedPreferences;

  AuthenticationLocalDataSourceImpl({
    required this.sharedPreferences
  });
  
  @override
  Future<void> setToken(AuthenticationModel model) async {
    final result = await sharedPreferences.setString("CACHED_AUTHENTICATION", json.encode(model.toJSON()));

    if (!result) {
      throw CacheException(message: Failure.cacheError);
    }
  }
  
  @override
  Future<AuthenticationModel> getToken() {
    final result = sharedPreferences.getString("CACHED_AUTHENTICATION");
    
    if (result != null) {
      return Future.value(AuthenticationModel.fromJSON(json.decode(result)));
    }

    throw CacheException(message: Failure.cacheError);
  }

}