
import 'package:crosscheck/features/dashboard/data/models/data/dashboard_model.dart';
import 'package:http/http.dart' as http;

abstract class DashboardRemoteDataSource {
  
  Future<DashboardModel> getDashboard(String token);

}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {

  final http.Client client;

  const DashboardRemoteDataSourceImpl({
    required this.client
  });
  
  @override
  Future<DashboardModel> getDashboard(String token) {
    // TODO: implement getDashboard
    throw UnimplementedError();
  }
  
}