import 'dart:convert';

import 'package:arogyam/data/api_helper.dart';
import 'package:arogyam/models/slot.dart';
import 'package:arogyam/models/user.dart';
import 'package:flutter/material.dart';

class AdminRepository {
  const AdminRepository();

  Future<List<Slot>> fetchSlotsByDate(String date) async {
    final response = await ApiHelper.fetchSlotListForAdmin(date);
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

  Future<List<User>> fetchUserDetails(Map<String, dynamic>? filters) async {
    final response = await ApiHelper.fetchUserListForAdmin(filters);

    debugPrint('fetchUserDetails: response body ${response.body} : $response');

    if (response.statusCode > 300 || response.statusCode < 200) {
      throw ApiHelper.getApiException(response);
    }

    final users = jsonDecode(response.body)['users'] as List<dynamic>?;
    return users?.map((e) => User.fromMap(e)).toList(growable: false) ?? [];
  }
}
