import 'dart:convert';

import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/data/api_helper.dart';
import 'package:arogyam/data/preference_helper.dart';
import 'package:arogyam/models/slot.dart';
import 'package:flutter/foundation.dart';

class SlotRepository {
  const SlotRepository();

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

  Future<List<Slot>> fetchSlotsByDate(String date) async {
    final response = await ApiHelper.fetchSlotList(date);
    debugPrint('fetchSlotsByDate: response body ${response.body} : $response');

    if (response.statusCode > 300 || response.statusCode < 200) {
      throw ApiHelper.getApiException(response);
    }

    final slotMap = jsonDecode(response.body)[date] as List<dynamic>?;
    debugPrint("slotMap: $slotMap");
    slotMap?.forEach((element) {
      debugPrint('slot might be: $element');
    });
    return (slotMap ?? []).map((slotEntry) {
      final slotId = slotEntry.keys.first;
      final availableDoses = slotEntry[slotId]['availableDoses'] ?? 10;
      return Slot.fromSlotId(slotId, dosesRemaining: availableDoses);
    }).toList(growable: false);
  }
}
