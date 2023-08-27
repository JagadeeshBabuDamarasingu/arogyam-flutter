import 'package:arogyam/bloc/app_event.dart';
import 'package:arogyam/bloc/user/user_state.dart';

sealed class UserEvent extends AppEvent {
  const UserEvent();
}

class UserDetailsRequested extends UserEvent {
  final bool refresh;
  const UserDetailsRequested({this.refresh = false});
}

class ManageSlotOperationEvent extends UserEvent {
  final ManageSlotOperation operation;
  final String slotId;
  final String? oldSlotId;

  const ManageSlotOperationEvent({
    required this.operation,
    required this.slotId,
    this.oldSlotId,
  });
}
