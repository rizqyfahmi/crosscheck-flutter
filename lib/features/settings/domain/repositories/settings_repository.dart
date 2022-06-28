import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class SettingsRepository {

  Future<void> setTheme(Brightness themeMode);

  Future<Either<Failure, SettingsEntity>> getTheme();
  
}