import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable{
  
  @override
  List<Object?> get props => [];

}

class DashboardGetData extends DashboardEvent {}
class DashboardResetData extends DashboardEvent {}
class DashboardResetGeneralError extends DashboardEvent {}