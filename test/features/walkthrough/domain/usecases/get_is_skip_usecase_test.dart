import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/walkthrough/domain/entities/walkthrough_entitiy.dart';
import 'package:crosscheck/features/walkthrough/domain/repositories/walkthrough_repository.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/get_is_skip_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_is_skip_usecase_test.mocks.dart';

@GenerateMocks([
  WalkthroughRepository
])
void main() {
  late MockWalkthroughRepository mockWalkthroughRepository;
  late GetIsSkipUsecase getIsSkipUsecase;

  setUp(() {
    mockWalkthroughRepository = MockWalkthroughRepository();
    getIsSkipUsecase = GetIsSkipUsecase(repository: mockWalkthroughRepository);
  });

  test("Should get cached \"isSkip\" status properly", () async {
    when(mockWalkthroughRepository.getIsSkip()).thenAnswer((_) async => const Right(WalkthroughEntity(isSkip: true)));

    final result = await getIsSkipUsecase(NoParam());

    expect(result, const Right(WalkthroughEntity(isSkip: true)));
    verify(mockWalkthroughRepository.getIsSkip());
  });

  test("Should not get \"is skip\" status and return CachedFailure when error is happened", () async {
    when(mockWalkthroughRepository.getIsSkip()).thenAnswer((_) async => Left(CacheException(message: Failure.cacheError)));

    final result = await getIsSkipUsecase(NoParam());

    expect(result, Left(CacheException(message: Failure.cacheError)));
    verify(mockWalkthroughRepository.getIsSkip());
  });
}