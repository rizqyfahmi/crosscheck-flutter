import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/settings/data/models/params/settings_params.dart';
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SettingsRepository {

  Future<void> setTheme(SettingsParams params);

  Future<Either<Failure, SettingsEntity>> getTheme();
  
}