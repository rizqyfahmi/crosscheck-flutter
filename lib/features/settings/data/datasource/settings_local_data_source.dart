import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';

abstract class SettingsLocalDataSource {
  
  Future<void> setTheme(SettingsModel params);

}