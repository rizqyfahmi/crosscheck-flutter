import 'dart:convert';

import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:crosscheck/features/profile/data/models/data/profile_model.dart';
import 'package:crosscheck/features/profile/data/models/response/profile_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/stringify.dart';
import '../../../../utils/utils.dart';
import 'profile_remote_data_source_test.mocks.dart';

@GenerateMocks([
  Client
])
void main() {
  late MockClient mockClient;
  late ProfileRemoteDataSource profileRemoteDataSource;
  late Map<String, String> headers;

  setUp(() {
    mockClient = MockClient();
    profileRemoteDataSource = ProfileRemoteDataSourceImpl(client: mockClient);
    headers = {'Content-Type': 'application/json', "Authorization": Utils.token};
  });

  test('Should returns ProfileModel properly when the request has succeeded', () async {
    final response = stringify("test/features/profile/data/datasource/profile_remote_data_source_success_response.json");
    when(mockClient.post(any, headers: headers)).thenAnswer((_) async => Response(response, 200));

    final result = await profileRemoteDataSource.getProfile(token: Utils.token);

    expect(result, ProfileResponseModel(message: Utils.successMessage, data: ProfileModel(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60")));
    verify(mockClient.post(any, headers: headers));
  });

  test('Should returns ProfileModel properly when the request has succeeded with empty string', () async {
    final response = stringify("test/features/profile/data/datasource/profile_remote_data_source_empty_string_success_response.json");
    when(mockClient.post(any, headers: headers)).thenAnswer((_) async => Response(response, 200));

    final result = await profileRemoteDataSource.getProfile(token: Utils.token);

    expect(result, const ProfileResponseModel(message: Utils.successMessage, data: ProfileModel(id: "123", fullname: "fulan", email: "fulan@email.com", dob: null, address: null, photoUrl: null)));
    verify(mockClient.post(any, headers: headers));
  });

  test('Should returns ProfileModel properly when the request has succeeded with null value', () async {
    final response = stringify("test/features/profile/data/datasource/profile_remote_data_source_null_value_success_response.json");
    when(mockClient.post(any, headers: headers)).thenAnswer((_) async => Response(response, 200));

    final result = await profileRemoteDataSource.getProfile(token: Utils.token);

    expect(result, const ProfileResponseModel(message: Utils.successMessage, data: ProfileModel(id: "123", fullname: "fulan", email: "fulan@email.com", dob: null, address: null, photoUrl: null)));
    verify(mockClient.post(any, headers: headers));
  });

  test('Should returns ServerException when response code is not 200', () {
    when(mockClient.post(any, headers: headers)).thenAnswer((_) async => Response(json.encode({"message":  Failure.generalError}), 500));

    final call = profileRemoteDataSource.getProfile;

    expect(() => call(token: Utils.token), throwsA(
      predicate((error) => error is ServerFailure)
    ));
    verify(mockClient.post(any, headers: headers));

  });
}