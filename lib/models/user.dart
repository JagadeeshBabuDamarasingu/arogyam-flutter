import 'package:arogyam/enums/vaccination_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class User extends Equatable {
  final String name;
  final String phoneNumber;
  final String aadharNo;
  final bool isAdmin;
  final int pinCode;
  final int age;
  final VaccinationStatus status;
  final List<String> slots;

  const User({
    required this.name,
    required this.phoneNumber,
    required this.aadharNo,
    required this.pinCode,
    required this.age,
    required this.slots,
    this.status = VaccinationStatus.none,
    this.isAdmin = false,
  });

  String getAadhar({bool masked = true, bool format = false}) {
    var aadhar = aadharNo;
    if (masked) aadhar = aadhar.substring(8).padLeft(12, 'X');
    if (format) aadhar = '${aadhar.substring(0, 4)} ${aadhar.substring(4, 8)} ${aadhar.substring(8)}';
    return aadhar;
  }

  @override
  List<Object?> get props => [
        name,
        age,
        pinCode,
        aadharNo,
        phoneNumber,
        status,
        slots,
        isAdmin,
      ];

  factory User.fromMap(Map<String, dynamic> map) {
    debugPrint("User: userMap => $map");
    final slots = (map['slots'] ?? []) as List<dynamic>;

    return User(
      name: map['name'],
      phoneNumber: map['phone'] ?? 'XXXXXXXXXX',
      aadharNo: map['aadhar'] ?? 'XXXX XXXX XXXX',
      pinCode: map['pincode'] ?? 0,
      age: map['age'] ?? 0,
      isAdmin: map['role'] == 0,
      status: VaccinationStatus.fromStatus(map['status']),
      slots: slots.map((e) => e as String).toList(growable: false),
    );
  }
}
