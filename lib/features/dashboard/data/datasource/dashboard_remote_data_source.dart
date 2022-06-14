import 'package:crosscheck/features/dashboard/data/models/data/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  
  Future<DashboardModel> getDashboard(String token);

}