part of 'admin_bloc.dart';

abstract class AdminEvent extends AppEvent {
  const AdminEvent();
}

class OnSlotDetailsRequested extends AdminEvent {
  final String slotDate;

  const OnSlotDetailsRequested({required this.slotDate});
}
