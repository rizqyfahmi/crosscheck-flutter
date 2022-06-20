import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';
import 'package:crosscheck/features/settings/domain/usecase/set_theme_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'set_theme_usecase_test.mocks.dart';

@GenerateMocks([
  SettingsRepository
])
void main() {
  late MockSettingsRepository mockSettingsRepository;
  late SetThemeUsecase setThemeUsecase;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    setThemeUsecase = SetThemeUsecase(repository: mockSettingsRepository);
  });

  test("Should set theme properly", () async {
    when(mockSettingsRepository.setTheme(any)).thenAnswer((_) async => Future.value());

    final result = await setThemeUsecase(const SettingsModel(themeMode: Brightness.light));

    verify(mockSettingsRepository.setTheme(const SettingsModel(themeMode: Brightness.light)));
    expect(result, const Right(null));
  });

  test("Should return CachedFailure when set theme is failed", () async {
    when(mockSettingsRepository.setTheme(any)).thenThrow(CacheException(message: Failure.cacheError));

    final result = await setThemeUsecase(const SettingsModel(themeMode: Brightness.light));

    verify(mockSettingsRepository.setTheme(const SettingsModel(themeMode: Brightness.light)));
    expect(result, Left(CachedFailure(message: Failure.cacheError)));
  });
}