import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/activity_model.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  
  final GetDashboardUsecase getDashboardUsecase;

  DashboardBloc({required this.getDashboardUsecase}) : super(DashboardInit()) {
    on<DashboardGetData>((event, emit) async {
      emit(DashboardLoading(model: state.model));

      final response = await getDashboardUsecase(NoParam());

      response.fold(
        (error) {
          if (error is! ServerFailure) return;
          emit(DashboardGeneralError(message: error.message, model: state.model));
        }, 
        (result) {
          String taskText = state.model.taskText;
          final double weeklyTotal = result.activities.map((e) => double.parse(e.total.toString())).reduce((value, result) => value + result);
          final activities = result.activities.map((activity) {
            final calculatedProgress = (activity.total / weeklyTotal) * 100;
            return ActivityModel(
              progress: (calculatedProgress).toStringAsFixed(0), 
              isActive: DateTime.now().weekday == activity.date.weekday,
              heightBar: (calculatedProgress / 100) * 160, // 160 from height of chart on the dashboard page
              date: activity.date, 
              total: activity.total
            );
          }).toList();

          if (result.upcoming == 1) {
            taskText = "You have ${int.parse(result.upcoming.toString())} task right now";
          }

          if (result.upcoming > 1) {
            taskText = "You have ${int.parse(result.upcoming.toString())} tasks right now";
          }

          final model = state.model.copyWith(
            fullname: result.fullname ?? "-",
            photoUrl: result.photoUrl ?? "https://via.placeholder.com/60x60/F24B59/F24B59?text=.",
            taskText: taskText,
            activities: activities,
            upcoming: result.upcoming,
            progress: getProgress(result.progress),
            completed: result.completed
          );

          emit(DashboardSuccess(model: model));
        }
      );
    });
    on<DashboardResetData>((event, emit) {
      emit(DashboardInit());
    });
    on<DashboardResetGeneralError>((event, emit) {
      emit(DashboardNoGeneralError(model: state.model));
    });
  }

  String getProgress(double rawProgress) {
    final splittedTest = rawProgress.toString().split(".");
    final beforeComma = splittedTest[0];
    final afterComma = splittedTest[1];

    String result = beforeComma;
    if (int.parse(afterComma) > 0) {
      result = rawProgress.toStringAsFixed(2);
    }

    return "$result%";
  }
  
}