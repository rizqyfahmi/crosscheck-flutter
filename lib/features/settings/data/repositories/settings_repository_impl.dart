import 'package:crosscheck/features/settings/data/datasource/settings_local_data_source.dart';
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {

  final SettingsLocalDataSource settingsLocalDataSource;

  const SettingsRepositoryImpl({required this.settingsLocalDataSource});
  
  @override
  Future<void> setTheme(SettingsModel params) {
    // TODO: implement setTheme
    throw UnimplementedError();
  }
  
}