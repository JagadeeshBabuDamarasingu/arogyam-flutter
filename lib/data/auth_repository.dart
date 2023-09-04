import 'dart:async';
import 'dart:convert';

import 'package:arogyam/data/api_helper.dart';
import 'package:arogyam/data/preference_helper.dart';
import 'package:arogyam/models/slot.dart';
import 'package:arogyam/models/user.dart';
import 'package:flutter/cupertino.dart';

class AuthRepository {
  const AuthRepository();

  Future<bool> _storeAuthHeader(Map<String, dynamic> body) async {
    final headerDecoded = '${body['phone']}:${body['password']}';
    final base64Encoded = base64Encode(utf8.encode(headerDecoded));
    return PreferencesHelper.storeAuthHeader('Basic $base64Encoded');
  }

  Future<User> logUser(Map<String, dynamic> body) async {
    final response = await ApiHelper.login(body);
    debugPrint('logUser: response body ${response.body} : ${response.statusCode}');

    if (response.statusCode > 300 || response.statusCode < 200) {
      throw ApiHelper.getApiException(response);
    }

    final userMap = jsonDecode(response.body);

    await PreferencesHelper.storeUser(userMap);
    await _storeAuthHeader(body);

    return User.fromMap(userMap);
  }

  Future<User> registerUser(Map<String, dynamic> userMap) async {
    final response = await ApiHelper.register(userMap);
    debugPrint('register: response body ${response.body} : $response');

    if (response.statusCode > 300 || response.statusCode < 200) {
      throw ApiHelper.getApiException(response);
    }

    await _storeAuthHeader(userMap);

    userMap.remove('password');

    userMap['slots'] = [];
    userMap['status'] = 0;
    userMap['role'] = 1;

    await PreferencesHelper.storeUser(userMap);
    return User.fromMap(userMap);
  }
}
