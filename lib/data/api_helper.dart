import 'dart:convert';
import 'dart:core';
import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/data/preference_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String _stage = "Prod";
  static const String _apiVersion = "v1";
  static const String _authority =
      "utarlfmvmh.execute-api.ap-south-1.amazonaws.com";
  static const String _basePath = '$_stage/api/$_apiVersion';

  // no public instances allowed
  ApiHelper._();

  static ApiException getApiException(http.Response response) {
    final errorMessage =
        jsonDecode(response.body)['message'] ?? "Unknown error";
    return switch (response.statusCode) {
      400 => BadRequestException(errorMessage),
      401 => UnauthorisedException(errorMessage),
      403 =>
        ForbiddenException('You are not authorized to access this resource'),
      500 || _ => FetchDataException(errorMessage)
    };
  }

  static Future<http.Response> login(Map<String, dynamic> body) async {
    final uri = Uri.https(_authority, '$_basePath/auth/login');
    return http.post(uri, body: jsonEncode(body));
  }

  static Future<http.Response> register(Map<String, dynamic> body) async {
    final uri = Uri.https(_authority, '$_basePath/auth/register');
    return http.post(uri, body: jsonEncode(body));
  }

  static Future<http.Response> fetchSlotList(String day) async {
    final url = Uri.https(_authority, '$_basePath/slots/getAllSlots/$day');
    return http.get(url);
  }

  static Future<http.Response> refreshUserSlots() async {
    final headers = <String, String>{};
    final authHeader = await PreferencesHelper.generateAuthHeader();
    if (authHeader != null) headers['Authorization'] = authHeader;
    final url = Uri.https(_authority, '$_basePath/user/getAllSlots');

    debugPrint("refreshUserSlots: headers => $headers");

    return http.get(url, headers: headers);
  }

  static Future<http.Response> manageSlot(
    ManageSlotOperation operation,
    String slotId, {
    String? oldSlotId,
  }) async {
    final uri = Uri.https(_authority, '$_basePath/user/manageSlot');
    final authHeader = await PreferencesHelper.generateAuthHeader();
    final headers = <String, String>{};
    if (authHeader != null) headers['Authorization'] = authHeader;
    final body = {'slotId': slotId};
    if (oldSlotId != null) body['oldSlotId'] = oldSlotId;
    if (operation == ManageSlotOperation.update) {
      body['operation'] = 'update';
    }

    final encodedBody = jsonEncode(body);

    debugPrint("manageSlot($operation): headers => $headers");
    debugPrint("manageSlot($operation): body => $body");
    debugPrint("manageSlot($operation): encoded body => $encodedBody");



    return switch (operation) {
      ManageSlotOperation.delete =>
        http.delete(uri, headers: headers, body: encodedBody),
      ManageSlotOperation.create ||
      ManageSlotOperation.update =>
        http.post(uri, body: encodedBody, headers: headers),
    };
  }
}

sealed class ApiException implements Exception {
  final _message;
  final _prefix;

  ApiException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends ApiException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class ForbiddenException extends ApiException {
  ForbiddenException([message]) : super(message, "Forbidden: ");
}
