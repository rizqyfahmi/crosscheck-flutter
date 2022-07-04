import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/task/data/models/response/task_response_model.dart';
import 'package:http/http.dart';

abstract class TaskRemoteDataSource {
  
  Future<TaskResponseModel> getHistory({required String token});

  Future<TaskResponseModel> getMoreHistory({required String token, required int limit, required int offset});

}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {

  final Client client;

  TaskRemoteDataSourceImpl({
    required this.client
  });

  @override
  Future<TaskResponseModel> getHistory({required String token}) async {
    final uri = Uri.parse("https://localhost:8080/task/history");
    final headers = {'Content-Type': 'application/json', "Authorization": token};
    final response = await client.get(uri, headers: headers);

    final body = await json.decode(response.body);

    if (response.statusCode == 200) {
      return TaskResponseModel.fromJSON(body);
    }

    throw ServerException(message: body["message"]);
  }
  
  @override
  Future<TaskResponseModel> getMoreHistory({required String token, required int limit, required int offset}) {
    // TODO: implement getMoreHistory
    throw UnimplementedError();
  }
  
}