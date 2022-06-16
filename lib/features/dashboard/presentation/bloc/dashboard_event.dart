import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable{
  
  @override
  List<Object?> get props => [];

}

class DashboardGetData extends DashboardEvent {
  final String token;
  
  DashboardGetData({
    required this.token
  });

  @override
  List<Object?> get props => [token];
}

class DashboardResetData extends DashboardEvent {}
class DashboardResetGeneralError extends DashboardEvent {}