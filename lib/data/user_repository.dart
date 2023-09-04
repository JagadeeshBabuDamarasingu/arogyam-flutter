import 'dart:convert';

import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/data/api_helper.dart';
import 'package:arogyam/data/preference_helper.dart';
import 'package:arogyam/models/slot.dart';
import 'package:flutter/foundation.dart';

class UserRepository {
  UserRepository();

  Slot _slotIdToSlot(slotId) => Slot.fromSlotId(slotId);

  Future<bool> isAdmin() async {
    final user = await PreferencesHelper.getUser();
    return user['role'] == 0;
  }

  Future<String> manageSlot(
    ManageSlotOperation operation,
    String slotId, {
    String? oldSlotId,
  }) async {
    final response =
        await ApiHelper.manageSlot(operation, slotId, oldSlotId: oldSlotId);
    debugPrint('manageSlot: response body ${response.body} : $response');

    if (response.statusCode > 300 || response.statusCode < 200) {
      throw ApiHelper.getApiException(response);
    }

    final decodedResponse = jsonDecode(response.body);
    final slots = (decodedResponse['updatedSlots'] ?? []) as List<dynamic>;
    await PreferencesHelper.updateUserSlot(slots.map((e) => e as String).toList(growable: false));

    return decodedResponse['message'];
  }

  Future<List<Slot>> fetchSlotList({refresh = false}) async {
    if (refresh) {
      final response = await ApiHelper.refreshUserSlots();
      debugPrint('fetchSlotList: response body ${response.body} : $response');

      if (response.statusCode > 300 || response.statusCode < 200) {
        throw ApiHelper.getApiException(response);
      }

      final slots = (jsonDecode(response.body)['slots'] ?? []) as List<dynamic>;
      final slotList = slots.map(_slotIdToSlot).toList(growable: false);

      await PreferencesHelper.updateUserSlot(slots.map((e) => e as String).toList(growable: false));
      return slotList;
    }

    final userMap = await PreferencesHelper.getUser();
    final userSlots = (userMap['slots'] ?? []) as List<dynamic>;
    return userSlots.map(_slotIdToSlot).toList(growable: false);
  }
}
