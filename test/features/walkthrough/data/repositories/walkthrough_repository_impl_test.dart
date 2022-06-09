import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/walkthrough/data/datasource/walkthrough_local_data_storage.dart';
import 'package:crosscheck/features/walkthrough/data/models/data/walkthrough_model.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:crosscheck/features/walkthrough/data/repositories/walkthrough_repository_impl.dart';
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
    when(mockWalkthroughLocalDataSource.setIsSkip(true)).thenAnswer((_) async {});

    final result = await walkthroughRepository.setIsSkip(const WalkthroughParams(isSkip: true));

    expect(result, const Right(null));
    verify(mockWalkthroughLocalDataSource.setIsSkip(true));
  });

  test("Should not set \"is skip\" status and return CachedFailure when error is happened", () async {
    when(mockWalkthroughLocalDataSource.setIsSkip(true)).thenThrow(CacheException(message: Failure.generalError));

    final result = await walkthroughRepository.setIsSkip(const WalkthroughParams(isSkip: true));

    expect(result, Left(CachedFailure(message: Failure.generalError)));
    verify(mockWalkthroughLocalDataSource.setIsSkip(true));
  });
}