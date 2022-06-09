
import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WalkthroughLocalDataSource {
  
  Future<void> setIsSkip(WalkthroughParams params);

}

class WalkthroughLocalDataSourceImpl implements WalkthroughLocalDataSource {

  final SharedPreferences sharedPreferences;

  WalkthroughLocalDataSourceImpl({
    required this.sharedPreferences
  });
  
  @override
  Future<void> setIsSkip(WalkthroughParams params) async {
    final response = await sharedPreferences.setString("CACHED_WALKTHROUGH", jsonEncode(params.toJSON()));

    if (!response) {
      throw CacheException(message: Failure.cacheError);
    }
  }

}