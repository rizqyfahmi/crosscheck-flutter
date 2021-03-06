import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:crosscheck/features/walkthrough/domain/repositories/walkthrough_repository.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/set_is_skip_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'set_is_skip_usecase_test.mocks.dart';

@GenerateMocks([
  WalkthroughRepository
])
void main() {

  late MockWalkthroughRepository mockWalkthroughRepository;
  late SetIsSkipUsecase setIsSkipUsecase;

  setUp(() {
    mockWalkthroughRepository = MockWalkthroughRepository();
    setIsSkipUsecase = SetIsSkipUsecase(repository: mockWalkthroughRepository);
  });

  test("Should set \"is skip\" status", () async {
    when(mockWalkthroughRepository.setIsSkip(true)).thenAnswer((_) async => const Right(null));

    final result = await setIsSkipUsecase(WalkthroughParams(isSkip: true));

    expect(result, const Right(null));
    verify(setIsSkipUsecase(WalkthroughParams(isSkip: true)));
  });

  test("Should not set \"is skip\" status and return CachedFailure when error is happened", () async {
    when(mockWalkthroughRepository.setIsSkip(true)).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));

    final result = await setIsSkipUsecase(WalkthroughParams(isSkip: true));

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    verify(setIsSkipUsecase(WalkthroughParams(isSkip: true)));
  });
}
