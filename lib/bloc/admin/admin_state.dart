part of 'admin_bloc.dart';

abstract class AdminState extends AppState {
  const AdminState();
}

class SlotListLoading extends AdminState {
  const SlotListLoading();
}

class OnSlotListLoaded extends AdminState {
  final List<Slot> slotList;

  const OnSlotListLoaded({required this.slotList});
}
