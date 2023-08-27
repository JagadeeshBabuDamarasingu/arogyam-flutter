import 'package:arogyam/bloc/app_event.dart';
import 'package:arogyam/bloc/user/user_state.dart';

abstract class SlotEvent extends AppEvent {
  const SlotEvent();
}

class OnSlotListRequested extends SlotEvent {
  final String slotDate;

  const OnSlotListRequested({
    required this.slotDate,
  });
}

class ManageSlotOperationEvent extends SlotEvent {
  final ManageSlotOperation operation;
  final String slotId;
  final String? oldSlotId;

  const ManageSlotOperationEvent({
    required this.operation,
    required this.slotId,
    this.oldSlotId,
  });
}