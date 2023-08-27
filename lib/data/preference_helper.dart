import 'dart:convert';

import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  // no public constructors allowed
  PreferencesHelper._();

  static const _keyUser = "logged_in_user";
  static const _authHeader = "auth_header";

  static Future<String?> generateAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authHeader);
  }

  static Future<bool> storeAuthHeader(String header) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_authHeader, header);
  }

  static Future<void> storeUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyUser, jsonEncode(user));
  }

  static Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUser);
    return userString == null ? {} : jsonDecode(userString);
  }

  static Future<void> updateUserSlotByOp(
    ManageSlotOperation operation,
    String slotId, {
    String? oldSlotId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUser);
    final user = User.fromMap(jsonDecode(userString ?? '{}'));
    switch (operation) {
      case ManageSlotOperation.create:{
          user.slots.add(slotId);
        }
      case ManageSlotOperation.update:{
          user.slots.remove(oldSlotId);
          user.slots.add(slotId);
        }
      case ManageSlotOperation.delete:{
          user.slots.remove(slotId);
        }
    }
    return storeUser(jsonDecode(jsonEncode(user)));
  }

  static Future<void> updateUserSlot(List<String> slotList) async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUser);
    final user = userString == null ? {} : jsonDecode(userString);
    user['slots'] = slotList;
    return storeUser(user);
  }
}
