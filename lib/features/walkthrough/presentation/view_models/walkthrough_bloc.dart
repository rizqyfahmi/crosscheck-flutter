import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/walkthrough/data/models/request/walkthrough_params.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/get_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/domain/usecases/set_is_skip_usecase.dart';
import 'package:crosscheck/features/walkthrough/presentation/view_models/walkthrough_event.dart';
import 'package:crosscheck/features/walkthrough/presentation/view_models/walkthrough_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalkthroughBloc extends Bloc<WalkthroughEvent, WalkthroughState> {
  
  final SetIsSkipUsecase setIsSkipUsecase;
  final GetIsSkipUsecase getIsSkipUsecase;

  WalkthroughBloc({
    required this.setIsSkipUsecase,
    required this.getIsSkipUsecase
  }) : super(const WalkthroughInitial()) {
    on<WalkthroughSetSkip>((event, emit) async {
      final response = await setIsSkipUsecase(WalkthroughParams(isSkip: event.isSkip));
      
      response.fold(
        (error) {
          if (error is! CachedFailure) return;
          emit(WalkthroughSkipFailed(model: state.model, message: error.message));
        }, 
        (_) {
          emit(WalkthroughSkipSuccess(model: state.model.copyWith(isSkip: event.isSkip)));
        }
      );
    });
    on<WalkthroughGetSkip>((event, emit) async {
      final response = await getIsSkipUsecase(NoParam());

      response.fold(
        (error) {
          if (error is! CachedFailure) return;
          emit(WalkthroughLoadSkipFailed(model: state.model, message: error.message));
        }, 
        (result) {
          emit(WalkthroughLoadSkipSuccess(model: state.model.copyWith(isSkip: result.isSkip)));
        }
      );
    });
  }
  
}