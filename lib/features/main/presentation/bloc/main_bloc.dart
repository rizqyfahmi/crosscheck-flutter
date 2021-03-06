import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/main/data/model/params/bottom_navigation_params.dart';
import 'package:crosscheck/features/main/domain/usecase/get_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/domain/usecase/set_active_bottom_navigation_usecase.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_event.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  final GetActiveBottomNavigationUsecase getActiveBottomNavigationUsecase;
  final SetActiveBottomNavigationUsecase setActiveBottomNavigationUsecase;

  MainBloc({
    required this.getActiveBottomNavigationUsecase,
    required this.setActiveBottomNavigationUsecase
  }) : super(const MainInit()) {
    on<MainGetActiveBottomNavigation>((event, emit) async {
      final response = await getActiveBottomNavigationUsecase(NoParam());
      response.fold(
        (error) {
          emit(state);
        }, 
        (result) {
          emit(MainChanged(model: state.model.copyWith(currentPage: result.currentPage)));
        }
      );
    });
    on<MainSetActiveBottomNavigation>((event, emit) async {
      final response = await setActiveBottomNavigationUsecase(BottomNavigationParams(currentPage: event.currentPage));
      response.fold(
        (error) {
          emit(state);
        }, 
        (result) {
          emit(MainChanged(model: state.model.copyWith(currentPage: result.currentPage)));
        }
      );
    });
    on<MainResetActiveBottomNavigation>((event, emit) {
      emit(const MainInit());
    });
    on<MainShowLoading>((event, emit) {
      emit(MainLoading(model: state.model));
    });
    on<MainHideLoading>((event, emit) {
      emit(MainLoadingCompleted(model: state.model));
    });
    on<MainSetGeneralError>((event, emit) {
     emit(MainGeneralError(message: event.message, model: state.model)); 
    });
    on<MainResetGeneralError>((event, emit) {
      emit(MainNoGeneralError(model: state.model));
    });
  }
  
}