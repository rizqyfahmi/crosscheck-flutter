import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/task/data/models/response/monthly_task_response_model.dart';
import 'package:crosscheck/features/task/data/models/response/task_response_model.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

abstract class TaskRemoteDataSource {
  
  Future<TaskResponseModel> getHistory({required String token, int? limit, int? offset});

  Future<MonthlyTaskResponseModel> getMonthlyTask({
    required String token,
    required DateTime time // "YYYY-MM"
  });

  Future<TaskResponseModel> getTaskByDate({required String token, required DateTime time, int? limit = 10, int? offset = 0});

}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {

  final Client client;

  TaskRemoteDataSourceImpl({
    required this.client
  });

  @override
  Future<TaskResponseModel> getHistory({required String token, int? limit = 10, int? offset = 0}) async {
    final uri = Uri.parse("http://localhost:8080/task/history?limit=$limit&offset=$offset");
    final headers = {'Content-Type': 'application/json', "Authorization": token};
    final response = await client.get(uri, headers: headers);

    final body = await json.decode(response.body);

    if (response.statusCode == 200) {
      return TaskResponseModel.fromJSON(body);
    }

    throw ServerException(message: body["message"]);
  }
  
  @override
  Future<MonthlyTaskResponseModel> getMonthlyTask({required String token, required DateTime time}) async {
    final uri = Uri.parse("http://localhost:8080/task/month/${DateFormat("YYYY-MM").format(time)}");
    final headers = {'Content-Type': 'application/json', "Authorization": token};
    final response = await client.get(uri, headers: headers);

    final body = await json.decode(response.body);

    if (response.statusCode == 200) {
      return MonthlyTaskResponseModel.fromJSON(body);
    }

    throw ServerException(message: body["message"]);
  }
  
  @override
  Future<TaskResponseModel> getTaskByDate({required String token, required DateTime time, int? limit = 10, int? offset = 0}) async {
    final uri = Uri.parse("http://localhost:8080/task/date/${DateFormat("YYYY-MM-DD").format(time)}?limit=$limit&offset=$offset");
    final headers = {'Content-Type': 'application/json', "Authorization": token};
    final response = await client.get(uri, headers: headers);

    final body = await json.decode(response.body);

    if (response.statusCode == 200) {
      return TaskResponseModel.fromJSON(body);
    }

    throw ServerException(message: body["message"]);
  }
  
}