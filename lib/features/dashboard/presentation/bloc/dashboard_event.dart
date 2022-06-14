import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable{
  
  @override
  List<Object?> get props => [];

}

class DashboardGetData extends DashboardEvent {
  final String token;
  final DateTime date;

  DashboardGetData({
    required this.token,
    required this.date
  });

  @override
  List<Object?> get props => [token];
}

class DashboardResetData extends DashboardEvent {}
class DashboardResetGeneralError extends DashboardEvent {}