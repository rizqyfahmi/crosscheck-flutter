import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SettingsRepository {

  Future<void> setTheme(SettingsModel params);

  Future<Either<Failure, SettingsEntity>> getTheme();
  
}