import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/walkthrough/data/datasource/walkthrough_local_data_source.dart';
import 'package:crosscheck/features/walkthrough/data/models/data/walkthrough_model.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:crosscheck/features/walkthrough/data/repositories/walkthrough_repository_impl.dart';
import 'package:crosscheck/features/walkthrough/domain/entities/walkthrough_entitiy.dart';
import 'package:crosscheck/features/walkthrough/domain/repositories/walkthrough_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'walkthrough_repository_impl_test.mocks.dart';

@GenerateMocks([
  WalkthroughLocalDataSource
])
void main() {
  late MockWalkthroughLocalDataSource mockWalkthroughLocalDataSource;
  late WalkthroughRepository walkthroughRepository;

  setUp(() {
    mockWalkthroughLocalDataSource = MockWalkthroughLocalDataSource();
    walkthroughRepository = WalkthroughRepositoryImpl(walkthroughLocalDataSource: mockWalkthroughLocalDataSource);
  });

  test("Should set \"isSkip\" status properly ", () async {
    final params = WalkthroughParams(isSkip: true);
    when(mockWalkthroughLocalDataSource.setIsSkip(params)).thenAnswer((_) async {});

    final result = await walkthroughRepository.setIsSkip(WalkthroughParams(isSkip: true));

    expect(result, const Right(null));
    verify(mockWalkthroughLocalDataSource.setIsSkip(params));
  });

  test("Should not set \"is skip\" status and return CachedFailure when error is happened", () async {
    final params = WalkthroughParams(isSkip: true);
    when(mockWalkthroughLocalDataSource.setIsSkip(params)).thenThrow(CacheException(message: Failure.generalError));

    final result = await walkthroughRepository.setIsSkip(WalkthroughParams(isSkip: true));

    expect(result, Left(CachedFailure(message: Failure.generalError)));
    verify(mockWalkthroughLocalDataSource.setIsSkip(params));
  });

  test("Should get \"isSkip\" status properly ", () async {
    WalkthroughEntity walkthroughEntity = const WalkthroughModel(isSkip: true);

    when(mockWalkthroughLocalDataSource.getIsSkip()).thenAnswer((_) async => const WalkthroughModel(isSkip: true));

    final result = await walkthroughRepository.getIsSkip();

    expect(result, Right(walkthroughEntity));
    verify(mockWalkthroughLocalDataSource.getIsSkip());
  });

  test("Should not get \"is skip\" status and return CachedFailure when error is happened", () async {
    when(mockWalkthroughLocalDataSource.getIsSkip()).thenThrow(CacheException(message: Failure.generalError));

    final result = await walkthroughRepository.getIsSkip();

    expect(result, Left(CachedFailure(message: Failure.generalError)));
    verify(mockWalkthroughLocalDataSource.getIsSkip());
  });
}