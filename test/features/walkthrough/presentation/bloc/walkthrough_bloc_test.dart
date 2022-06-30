import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:crosscheck/features/walkthrough/domain/entities/walkthrough_entitiy.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/get_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/set_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_bloc.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_event.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_model.dart';
import 'package:crosscheck/features/walkthrough/presentation/bloc/walkthrough_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'walkthrough_bloc_test.mocks.dart';

@GenerateMocks([
  SetIsSkipUsecase,
  GetIsSkipUsecase
])
void main() {
  late MockSetIsSkipUsecase mockSetIsSkipUsecase;
  late MockGetIsSkipUsecase mockGetIsSkipUsecase;
  late WalkthroughBloc bloc;

  setUp(() {
    mockSetIsSkipUsecase = MockSetIsSkipUsecase();
    mockGetIsSkipUsecase = MockGetIsSkipUsecase();
    bloc = WalkthroughBloc(
      setIsSkipUsecase: mockSetIsSkipUsecase,
      getIsSkipUsecase: mockGetIsSkipUsecase
    );
  });

  test("Should return WalkthroughInitial at first time", () {
    expect(bloc.state, const WalkthroughInitial());
  });

  test("Should return WalkthroughSkipSuccess when add WalkthroughSetSkip event is success", () async {
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const Right(null));

    bloc.add(const WalkthroughSetSkip(isSkip: true));

    final expected = [
      const WalkthroughSkipSuccess(model: WalkthroughModel(isSkip: true))
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    await untilCalled(mockSetIsSkipUsecase(any));

    verify(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true)));
  });

  test("Should return WalkthroughSkipFailed when add WalkthroughSetSkip event is error", () async {
    when(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true))).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));

    bloc.add(const WalkthroughSetSkip(isSkip: true));

    final expected = [
      // reset isSkip when the event is error
      const WalkthroughSkipFailed(model: WalkthroughModel(isSkip: false), message: Failure.cacheError)
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    await untilCalled(mockSetIsSkipUsecase(any));

    verify(mockSetIsSkipUsecase(WalkthroughParams(isSkip: true)));
  });

  test("Should return WalkthroughLoadSkipSuccess when add WalkthroughGetSkip event is success", () async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const Right(WalkthroughEntity(isSkip: true)));

    bloc.add(WalkthroughGetSkip());

    final expected = [
      const WalkthroughLoadSkipSuccess(model: WalkthroughModel(isSkip: true))
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    await untilCalled(mockGetIsSkipUsecase(any));

    verify(mockGetIsSkipUsecase(NoParam()));
  });

  test("Should return WalkthroughSkipFailed when add WalkthroughSetSkip event is error", () async {
    when(mockGetIsSkipUsecase(NoParam())).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));

    bloc.add(WalkthroughGetSkip());

    final expected = [
      // reset isSkip when the event is error
      const WalkthroughLoadSkipFailed(model: WalkthroughModel(isSkip: false), message: Failure.cacheError)
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    await untilCalled(mockGetIsSkipUsecase(any));

    verify(mockGetIsSkipUsecase(NoParam()));
  });
}