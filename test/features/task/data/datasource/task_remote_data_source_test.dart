import 'dart:convert';

import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/data/datasource/task_remote_data_source.dart';
import 'package:crosscheck/features/task/data/models/data/monthly_task_model.dart';
import 'package:crosscheck/features/task/data/models/response/monthly_task_response_model.dart';
import 'package:crosscheck/features/task/data/models/response/task_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/stringify.dart';
import '../../../../utils/utils.dart';
import 'task_remote_data_source_test.mocks.dart';

@GenerateMocks([
  Client
])
void main() {
  late MockClient mockClient;
  late TaskRemoteDataSource taskRemoteDataSource;

  setUp(() {
    mockClient = MockClient();
    taskRemoteDataSource = TaskRemoteDataSourceImpl(client: mockClient);
  });

  /*--------------------------------------------------- Get History ---------------------------------------------------*/ 
  test("Should properly returns TaskResponseModel with list of task model as its data", () async {
    final response = stringify("test/features/task/data/datasource/task_remote_data_source_success_response.json");
    when(mockClient.get(any, headers: Utils().headers)).thenAnswer((_) async => Response(response, 200));

    final result = await taskRemoteDataSource.getHistory(token: Utils.token);

    expect(result, TaskResponseModel(message: Utils.successMessage, data: Utils().taskModels));
    verify(mockClient.get(any, headers: Utils().headers));
  });

  test("Should properly returns TaskResponseModel with empty list of task model when response data is null", () async {
    final response = stringify("test/features/task/data/datasource/task_remote_data_source_success_null_data_response.json");
    when(mockClient.get(any, headers: Utils().headers)).thenAnswer((_) async => Response(response, 200));

    final result = await taskRemoteDataSource.getHistory(token: Utils.token);

    expect(result, const TaskResponseModel(message: Utils.successMessage, data: []));
    verify(mockClient.get(any, headers: Utils().headers));
  });

  test("Should properly returns TaskResponseModel with empty list of task model when response data is empty list", () async {
    final response = stringify("test/features/task/data/datasource/task_remote_data_source_success_empty_data_response.json");
    when(mockClient.get(any, headers: Utils().headers)).thenAnswer((_) async => Response(response, 200));

    final result = await taskRemoteDataSource.getHistory(token: Utils.token);

    expect(result, const TaskResponseModel(message: Utils.successMessage, data: []));
    verify(mockClient.get(any, headers: Utils().headers));
  });

  test("Should returns ServerException when get history from client is failed", () async {
    when(mockClient.get(any, headers: Utils().headers)).thenAnswer((_) async => Response(json.encode({"message": Failure.generalError}), 500));
    
    final call = taskRemoteDataSource.getHistory;

    expect(() => call(token: Utils.token), throwsA(
      predicate((error) => error is ServerFailure)
    ));
    verify(mockClient.get(any, headers: Utils().headers));
  });

  /*--------------------------------------------------- Get Monthly Task ---------------------------------------------------*/
  test("Should returns MonthlyTaskResponseModel properly", () async {
    final time = DateTime(2022, 7);
    final expected = [
      MonthlyTaskModel(id: "20220701", date: DateTime.parse("2022-07-01"), total: 1),
      MonthlyTaskModel(id: "20220702", date: DateTime.parse("2022-07-02"), total: 2),
      MonthlyTaskModel(id: "20220703", date: DateTime.parse("2022-07-03"), total: 3),
      MonthlyTaskModel(id: "20220704", date: DateTime.parse("2022-07-04"), total: 4),
      MonthlyTaskModel(id: "20220705", date: DateTime.parse("2022-07-05"), total: 5),
    ];
    final response = stringify("test/features/task/data/datasource/task_remote_data_source_success_monthly_task_response.json");
    when(mockClient.get(any, headers: Utils().headers)).thenAnswer((_) async => Response(response, 200));

    final result = await taskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time);

    expect(result, MonthlyTaskResponseModel(message: Utils.successMessage, data: expected));
    verify(mockClient.get(any, headers: Utils().headers));
  });

  test("Should returns MonthlyTaskResponseModel with empty list of data when data in response is null", () async {
    final time = DateTime(2022, 7);
    final expected = [];
    final response = stringify("test/features/task/data/datasource/task_remote_data_source_success_null_data_response.json");
    when(mockClient.get(any, headers: Utils().headers)).thenAnswer((_) async => Response(response, 200));

    final result = await taskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time);

    expect(result, MonthlyTaskResponseModel(message: Utils.successMessage, data: expected));
    verify(mockClient.get(any, headers: Utils().headers));
  });

  test("Should returns MonthlyTaskResponseModel with empty list of data when data in response contains empty list", () async {
    final time = DateTime(2022, 7);
    final expected = [];
    final response = stringify("test/features/task/data/datasource/task_remote_data_source_success_empty_data_response.json");
    when(mockClient.get(any, headers: Utils().headers)).thenAnswer((_) async => Response(response, 200));

    final result = await taskRemoteDataSource.getMonthlyTask(token: Utils.token, time: time);

    expect(result, MonthlyTaskResponseModel(message: Utils.successMessage, data: expected));
    verify(mockClient.get(any, headers: Utils().headers));
  });

  test("Should returns ServerException when Monthly Task from client is failed", () async {
    final time = DateTime(2022, 7);
    when(mockClient.get(any, headers: Utils().headers)).thenAnswer((_) async => Response(json.encode({"message": Failure.generalError}), 500));
    
    final call = taskRemoteDataSource.getMonthlyTask;

    expect(() => call(token: Utils.token, time: time), throwsA(
      predicate((error) => error is ServerFailure)
    ));
    verify(mockClient.get(any, headers: Utils().headers));
  });
}