import 'dart:convert';

import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../utils/stringify.dart';

void main() {
  late AuthenticationModel model;
  const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

  setUp(() {
    model = const AuthenticationModel(token: token);
  });

  test("Should be subclass of AuthenticationEntity", () {
    expect(model, isA<AuthenticationEntity>());
  });

  test("Should return a valid model from JSON Map", () {
    final String jsonString = stringify("test/features/authentication/data/models/data/authentication.json");
    final Map<String, dynamic> map = jsonDecode(jsonString);
    
    final result = AuthenticationModel.fromJSON(map);

    expect(result, model);
  });

  test("Should return a JSON Map from model", () {
    final result = model.toJSON();

    const expected = {
      "token": token
    };

    expect(result, expected);
  });
}