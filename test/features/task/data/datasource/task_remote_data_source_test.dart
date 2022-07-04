import 'dart:convert';

import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/task/data/datasource/task_remote_data_source.dart';
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
}