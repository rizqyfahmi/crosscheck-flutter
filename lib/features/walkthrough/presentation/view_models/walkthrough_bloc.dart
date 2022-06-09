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
    on<WalkthroughSetSkip>((event, emit) {});
    on<WalkthroughGetSkip>((event, emit) {});
  }
  
}