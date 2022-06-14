
import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/dashboard/data/datasource/dashboard_remote_data_source.dart';
import 'package:crosscheck/features/dashboard/data/models/data/activity_model.dart';
import 'package:crosscheck/features/dashboard/data/models/data/dashboard_model.dart';
import 'package:crosscheck/features/dashboard/domain/entities/activity_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../utils/stringify.dart';
import 'dashboard_remote_data_source_test.mocks.dart';

@GenerateMocks([
  http.Client
])
void main() {
  late MockClient mockClient;
  late DashboardRemoteDataSource dashboardRemoteDataSource;
  late Map<String, String> headers;
  late Uri uri;

  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  final currentDate = DateTime.parse("2022-06-14");
  final List<ActivityEntity> activities = [
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.monday)), total: 5),   
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.tuesday)), total: 7),
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.wednesday)), total: 3),
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.thursday)), total: 2),
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.friday)), total: 7),
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.saturday)), total: 1),
    ActivityModel(date: currentDate.subtract(Duration(days: currentDate.weekday - DateTime.sunday)), total: 5),
  ];
  const int upcoming = 20;
  const int completed = 5;
  final DashboardModel model = DashboardModel(progress: completed / (upcoming + completed), upcoming: upcoming, completed: completed, activities: activities);

  setUp(() {
    mockClient = MockClient();
    dashboardRemoteDataSource = DashboardRemoteDataSourceImpl(client: mockClient);
    headers = {'Content-Type': 'application/json', "Authorization": token};
    uri = Uri.parse("https://localhost:8080/dashboard");
  });

  test("Should return DashboardModel when get dashboard is success", () async {
    final String response = stringify("test/features/dashboard/data/datasource/dashboard_remote_data_source_success_response.json");
    when(mockClient.post(uri, headers: headers)).thenAnswer((_) async => http.Response(response, 200));

    final result = await dashboardRemoteDataSource.getDashboard(token);

    expect(result, model);
  });

  test("Should throw ServerException when get dashboard is failed", () async {
    when(mockClient.post(uri, headers: headers)).thenAnswer((_) async => http.Response(json.encode({"message": Failure.generalError}), 500));

    final call = dashboardRemoteDataSource.getDashboard(token);

    expect(
      () => call, 
      throwsA(
        predicate((error) => error is ServerException && error.message == Failure.generalError)
      )
    );
  });
}