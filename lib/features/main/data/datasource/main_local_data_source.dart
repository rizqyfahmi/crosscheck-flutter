import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/main/data/model/bottom_navigation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MainLocalDataSource {
  
  Future<BottomNavigationModel> getActiveBottomNavigation();

}

class MainLocalDataSourceImpl implements MainLocalDataSource {
  
  final SharedPreferences sharedPreferences;

  const MainLocalDataSourceImpl({
    required this.sharedPreferences
  });
  
  @override
  Future<BottomNavigationModel> getActiveBottomNavigation() {
    // TODO: implement getActiveBottomNavigation
    throw UnimplementedError();
  }
  
}