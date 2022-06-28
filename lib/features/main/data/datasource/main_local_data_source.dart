import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/main/data/model/data/bottom_navigation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MainLocalDataSource {
  
  Future<BottomNavigationModel> getActiveBottomNavigation();

  Future<void> setActiveBottomNavigation(BottomNavigationModel param);

}

class MainLocalDataSourceImpl implements MainLocalDataSource {
  
  final SharedPreferences sharedPreferences;

  const MainLocalDataSourceImpl({
    required this.sharedPreferences
  });
  
  @override
  Future<BottomNavigationModel> getActiveBottomNavigation() {
    final response = sharedPreferences.getString("CACHED_BOTTOM_NAVIGATION");

    if (response != null) return Future.value(BottomNavigationModel.fromJSON(json.decode(response)));

    throw CacheException(message: Failure.cacheError);
  }
  
  @override
  Future<void> setActiveBottomNavigation(BottomNavigationModel param) async {
    final response = await sharedPreferences.setString("CACHED_BOTTOM_NAVIGATION", json.encode(param.toJSON()));

    if (!response) {
      throw CacheException(message: Failure.cacheError);
    }
  }
  
}