import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/settings/data/datasource/settings_local_data_source.dart';
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class SettingsRepositoryImpl implements SettingsRepository {

  final SettingsLocalDataSource settingsLocalDataSource;

  const SettingsRepositoryImpl({required this.settingsLocalDataSource});
  
  @override
  Future<void> setTheme(SettingsModel params) async {
    await settingsLocalDataSource.setTheme(params);
  }

  @override
  Future<Either<Failure, SettingsEntity>> getTheme() {
    // TODO: implement getTheme
    throw UnimplementedError();
  }
  
}