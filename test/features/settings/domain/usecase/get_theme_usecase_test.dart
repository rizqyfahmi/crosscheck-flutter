
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';
import 'package:crosscheck/features/settings/domain/usecase/get_theme_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_theme_usecase_test.mocks.dart';

@GenerateMocks([
  SettingsRepository
])
void main() {
  late MockSettingsRepository mockSettingsRepository;
  late GetThemeUsecase getThemeUsecase;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    getThemeUsecase = GetThemeUsecase(repository: mockSettingsRepository);
  });

  test("Should get theme properly", () async {
    when(mockSettingsRepository.getTheme()).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.light)));

    final result = await getThemeUsecase(NoParam());

    expect(result, const Right(SettingsEntity(themeMode: Brightness.light)));
    verify(mockSettingsRepository.getTheme());
  });

  test("Should return CachedFaiure when get theme is failed", () async {
    when(mockSettingsRepository.getTheme()).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));

    final result = await getThemeUsecase(NoParam());

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(mockSettingsRepository.getTheme());
  });
  
}