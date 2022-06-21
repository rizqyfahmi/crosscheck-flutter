import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  
  Future<void> setTheme(SettingsModel params);

}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> setTheme(SettingsModel params) {
    // TODO: implement setTheme
    throw UnimplementedError();
  }
  
}