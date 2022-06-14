import 'package:crosscheck/core/param/param.dart';

class DashboardParams extends Param {
  
  final String token;

  DashboardParams({
    required this.token
  });

  @override
  List<Object?> get props => [token];

}