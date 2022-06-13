import 'package:crosscheck/core/param/param.dart';
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
          emit(MainChanged(model: state.model.copyWith(currentPageIndex: result.currentPageIndex)));
        }
      );
    });
    on<MainSetActiveBottomNavigation>((event, emit) async {});
  }
  
}