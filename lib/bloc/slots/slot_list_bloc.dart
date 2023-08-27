import 'package:arogyam/bloc/slots/slot_event.dart';
import 'package:arogyam/bloc/slots/slot_state.dart';
import 'package:arogyam/data/SlotRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SlotListBloc extends Bloc<SlotEvent, SlotState> {
  final SlotRepository _repository;

  SlotListBloc(this._repository) : super(const SlotListLoading()) {
    on<ManageSlotOperationEvent>((event, emit) async {
      final message = await _repository.manageSlot(
        event.operation,
        event.slotId,
        oldSlotId: event.oldSlotId,
      );
      emit(OnManageSlotResponse(message: message));
    });

    on<OnSlotListRequested>((event, emit) async {
      final slots = await _repository.fetchSlotsByDate(event.slotDate);
      slots.sort((a, b) => a.slotNumber - b.slotNumber);
      emit(SlotListLoaded(slotList: slots));
    });
  }
}
