import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/task/data/models/response/task_response_model.dart';
import 'package:http/http.dart';

abstract class TaskRemoteDataSource {
  
  Future<TaskResponseModel> getHistory({required String token, int? limit, int? offset});

}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {

  final Client client;

  TaskRemoteDataSourceImpl({
    required this.client
  });

  @override
  Future<TaskResponseModel> getHistory({required String token, int? limit = 10, int? offset = 0}) async {
    final uri = Uri(
      scheme: "https",
      path: "task/history",
      host: "localhost:8080",
      queryParameters: {
        "limit": limit,
        "offset": offset
      }
    );
    final headers = {'Content-Type': 'application/json', "Authorization": token};
    final response = await client.get(uri, headers: headers);

    final body = await json.decode(response.body);

    if (response.statusCode == 200) {
      return TaskResponseModel.fromJSON(body);
    }

    throw ServerException(message: body["message"]);
  }
  
}