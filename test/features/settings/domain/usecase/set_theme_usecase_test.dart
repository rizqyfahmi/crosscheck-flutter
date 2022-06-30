import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/settings/data/models/params/settings_params.dart';
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

    final params = SettingsParams(themeMode: Brightness.light);
    final result = await setThemeUsecase(params);

    verify(mockSettingsRepository.setTheme(params.themeMode));
    expect(result, const Right(null));
  });

  test("Should return CachedFailure when set theme is failed", () async {
    when(mockSettingsRepository.setTheme(any)).thenThrow(const CacheException(message: Failure.cacheError));

    final params = SettingsParams(themeMode: Brightness.light);
    final result = await setThemeUsecase(params);

    verify(mockSettingsRepository.setTheme(params.themeMode));
    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
  });
}