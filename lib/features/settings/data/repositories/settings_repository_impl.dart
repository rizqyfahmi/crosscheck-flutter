import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/settings/data/datasource/settings_local_data_source.dart';
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class SettingsRepositoryImpl implements SettingsRepository {

  final SettingsLocalDataSource settingsLocalDataSource;

  const SettingsRepositoryImpl({required this.settingsLocalDataSource});
  
  @override
  Future<void> setTheme(Brightness themeMode) async {
    await settingsLocalDataSource.setTheme(SettingsModel(themeMode: themeMode));
  }

  @override
  Future<Either<Failure, SettingsEntity>> getTheme() async {
    try {
      final response = await settingsLocalDataSource.getTheme();
      return Right(response);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
}