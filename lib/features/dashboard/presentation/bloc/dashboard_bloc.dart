import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  
  final GetDashboardUsecase getDashboardUsecase;

  DashboardBloc({required this.getDashboardUsecase}) : super(const DashboardInit()) {
    on<DashboardGetData>((event, emit) => null);
    on<DashboardResetData>((event, emit) => null);
    on<DashboardResetGeneralError>((event, emit) => null);
  }
  
}