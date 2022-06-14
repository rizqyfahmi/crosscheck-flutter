import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
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
  Future<DashboardModel> getDashboard(String token) async {
    final headers = {'Content-Type': 'application/json', "Authorization": token};
    final uri = Uri.parse("https://localhost:8080/dashboard");
    final response = await client.post(uri, headers: headers);
    
    final body = json.decode(response.body);

    if (response.statusCode == 200) {  
      return DashboardModel.fromJSON(body["data"]);
    }

    throw ServerException(message: body["message"]);
  }
  
}