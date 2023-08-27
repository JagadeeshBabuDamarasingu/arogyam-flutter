import 'package:arogyam/bloc/app_state.dart';
import 'package:arogyam/models/slot.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

enum ManageSlotOperation { create, update, delete }

// @freezed
sealed class UserState extends AppState {
  const UserState();
}

class UserDetailsLoading extends UserState {
  final String? message;

  const UserDetailsLoading({
    this.message = "Loading your slot details, please wait",
  });
}

class UserDetailsLoaded extends UserState {
  final bool isAdmin;
  final List<Slot> userSlotList;

  const UserDetailsLoaded({
    required this.userSlotList,
    this.isAdmin = false,
  });
}

// class OnManageSlotResponse extends UserState {
//   final String message;
//
//   const OnManageSlotResponse({required this.message});
// }
