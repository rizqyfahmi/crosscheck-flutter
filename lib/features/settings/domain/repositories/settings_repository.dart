import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';

abstract class SettingsRepository {

  Future<void> setTheme(SettingsModel params);
  
}