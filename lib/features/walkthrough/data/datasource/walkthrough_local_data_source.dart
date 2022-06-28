
import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/walkthrough/data/models/data/walkthrough_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WalkthroughLocalDataSource {
  
  Future<void> setIsSkip(WalkthroughModel model);

  Future<WalkthroughModel> getIsSkip();

}

class WalkthroughLocalDataSourceImpl implements WalkthroughLocalDataSource {

  final SharedPreferences sharedPreferences;

  WalkthroughLocalDataSourceImpl({
    required this.sharedPreferences
  });
  
  @override
  Future<void> setIsSkip(WalkthroughModel model) async {
    final response = await sharedPreferences.setString("CACHED_WALKTHROUGH", jsonEncode(model.toJSON()));

    if (!response) {
      throw CacheException(message: Failure.cacheError);
    }
  }
  
  @override
  Future<WalkthroughModel> getIsSkip() {
    final response = sharedPreferences.getString("CACHED_WALKTHROUGH");

    if (response != null) {
      return Future.value(WalkthroughModel.fromJSON(json.decode(response)));
    }

    throw CacheException(message: Failure.cacheError);

  }
  
}