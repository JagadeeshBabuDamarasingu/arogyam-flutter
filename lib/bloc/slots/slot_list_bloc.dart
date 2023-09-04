import 'package:arogyam/bloc/app_bloc.dart';
import 'package:arogyam/bloc/app_effect.dart';
import 'package:arogyam/bloc/slots/slot_event.dart';
import 'package:arogyam/bloc/slots/slot_state.dart';
import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/data/SlotRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SlotListBloc extends Bloc<SlotEvent, SlotState>
    with SideEffectProviderMixin<AppEffect> {
  final SlotRepository _repository;

  SlotListBloc(this._repository) : super(const SlotListLoading()) {
    on<ManageSlotOperationEvent>((event, emit) async {
      emit(ManageSlotLoading(message: _getLoadingMessage(event.operation)));
      try {
        final message = await _repository.manageSlot(
          event.operation,
          event.slotId,
          oldSlotId: event.oldSlotId,
        );
        emit(OnManageSlotResponse(message: message));
      } catch (error) {
        debugPrint("ManageSlotOperationEvent: error ${event.operation}");
        produceSideEffect(
          SnackBarEffect(
            message: _getErrorMessage(
              event.operation,
            ),
          ),
        );
      }
    });

    on<OnSlotListRequested>((event, emit) async {
      final slots = await _repository.fetchSlotsByDate(event.slotDate);
      slots.sort((a, b) => a.slotNumber - b.slotNumber);
      emit(SlotListLoaded(slotList: slots));
    });
  }

  _getErrorMessage(ManageSlotOperation operation) {
    return switch (operation) {
      ManageSlotOperation.create =>
        "Error scheduling your slot, try again later",
      ManageSlotOperation.update =>
        "Error re-scheduling your slot, try again later",
      ManageSlotOperation.delete =>
        "Error cancelling your slot, try again later",
    };
  }

  _getLoadingMessage(ManageSlotOperation operation) {
    return switch (operation) {
      ManageSlotOperation.create => "Scheduling your slot, please wait",
      ManageSlotOperation.update => "Re-scheduling your slot, please wait",
      ManageSlotOperation.delete => "Cancelling your slot, please wait",
    };
  }
}
