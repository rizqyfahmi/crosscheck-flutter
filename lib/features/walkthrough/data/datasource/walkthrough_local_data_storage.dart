
import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WalkthroughLocalDataSource {
  
  Future<void> setIsSkip(bool isSkip);

}

class WalkthroughLocalDataSourceImpl implements WalkthroughLocalDataSource {

  final SharedPreferences sharedPreferences;

  WalkthroughLocalDataSourceImpl({
    required this.sharedPreferences
  });
  
  @override
  Future<void> setIsSkip(bool isSkip) async {
    final response = await sharedPreferences.setBool("isSkip", isSkip);

    if (!response) {
      throw CacheException(message: Failure.cacheError);
    }
  }
  
}