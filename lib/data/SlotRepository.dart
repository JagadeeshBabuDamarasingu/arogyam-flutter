import 'dart:convert';

import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/data/api_helper.dart';
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

    return jsonDecode(response.body)['message'];
  }

  Future<List<Slot>> fetchSlotsByDate(String date) async {
    final response = await ApiHelper.fetchSlotList(date);
    debugPrint('fetchSlotsByDate: response body ${response.body} : $response');

    if (response.statusCode > 300 || response.statusCode < 200) {
      throw ApiHelper.getApiException(response);
    }

    final slotMap = jsonDecode(response.body)[date] as List<dynamic>?;
    return (slotMap ?? [])
        .map((e) =>
            Slot.fromSlotId(e.keys.first, dosesRemaining: e.values.first))
        .toList(growable: false);
  }
}
