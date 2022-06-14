import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_model.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {

  final DashboardModel model;

  const DashboardState({
    required this.model
  });

  @override
  List<Object?> get props => [model];

}

class DashboardInit extends DashboardState {
  
  const DashboardInit() : super(model: const DashboardModel());
  
}

class DashboardLoading extends DashboardState {
  
  const DashboardLoading({required super.model});
  
}

class DashboardSuccess extends DashboardState {
  
  const DashboardSuccess({required super.model});

}

class DashboardGeneralError extends DashboardState {
  
  final String message;

  const DashboardGeneralError({required this.message, required super.model});

  @override
  List<Object?> get props => [...super.props, message];
  
}

class DashboardNoGeneralError extends DashboardState {
  const DashboardNoGeneralError({required super.model});
}
