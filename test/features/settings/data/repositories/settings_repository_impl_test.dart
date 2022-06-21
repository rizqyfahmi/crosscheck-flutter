
import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/settings/data/datasource/settings_local_data_source.dart';
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:crosscheck/features/settings/data/models/params/settings_params.dart';
import 'package:crosscheck/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_repository_impl_test.mocks.dart';

@GenerateMocks([
  SettingsLocalDataSource
])
void main() {
  late MockSettingsLocalDataSource mockSettingsLocalDataSource;
  late SettingsRepository settingsRepository;

  setUp(() {
    mockSettingsLocalDataSource = MockSettingsLocalDataSource();
    settingsRepository = SettingsRepositoryImpl(settingsLocalDataSource: mockSettingsLocalDataSource);
  });

  test("Should set theme properly", () async {
    when(mockSettingsLocalDataSource.setTheme(any)).thenAnswer((_) async => Future.value());

    await settingsRepository.setTheme(const SettingsParams(themeMode: Brightness.light));

    verify(mockSettingsLocalDataSource.setTheme(const SettingsParams(themeMode: Brightness.light)));
  });

  test("Should return CacheExpection when set theme is failed", () async {
    const params = SettingsParams(themeMode: Brightness.light);
    when(mockSettingsLocalDataSource.setTheme(params)).thenThrow(CacheException(message: Failure.cacheError));

    final call = settingsRepository.setTheme;

    expect(call(params), throwsA(
      predicate((error) => error is CacheException
    )));

    verify(mockSettingsLocalDataSource.setTheme(params));
  });

  test("Should get theme properly", () async {
    when(mockSettingsLocalDataSource.getTheme()).thenAnswer((_) async => const SettingsModel(themeMode: Brightness.light));

    final result = await settingsRepository.getTheme();

    expect(result, const Right(SettingsModel(themeMode: Brightness.light)));

    verify(mockSettingsLocalDataSource.getTheme());
  });

  test("Should return CachedFailure when get theme is failed", () async {
    when(mockSettingsLocalDataSource.getTheme()).thenThrow(CacheException(message: Failure.cacheError));

    final result = await settingsRepository.getTheme();

    expect(result, Left(CachedFailure(message: Failure.cacheError)));

    verify(mockSettingsLocalDataSource.getTheme());
  });
}