import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  
  Future<void> setTheme(SettingsModel params);

  Future<SettingsModel> getTheme();

}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> setTheme(SettingsModel params) async {
    final response = await sharedPreferences.setString("CACHED_SETTINGS", json.encode(params.toJSON()));

    if (!response) {
      throw CacheException(message: Failure.cacheError);
    }
  }
  
  @override
  Future<SettingsModel> getTheme() {
    final response = sharedPreferences.getString("CACHED_SETTINGS");

    if (response != null) {
      return Future.value(SettingsModel.fromJSON(json.decode(response)));
    }

    throw CacheException(message: Failure.cacheError);
  }
  
}