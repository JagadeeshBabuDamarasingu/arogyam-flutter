import 'package:arogyam/bloc/app_state.dart';
import 'package:arogyam/models/slot.dart';

sealed class SlotState extends AppState {
  const SlotState();
}

class SlotListLoading extends SlotState {
  const SlotListLoading();
}

class SlotListLoaded extends SlotState {
  final List<Slot> slotList;

  const SlotListLoaded({required this.slotList});
}

class ManageSlotLoading extends SlotState {
  final String message;

  const ManageSlotLoading({required this.message});
}

class OnManageSlotResponse extends SlotState {
  final String message;

  const OnManageSlotResponse({required this.message});
}