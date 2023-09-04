import 'package:arogyam/bloc/app_bloc.dart';
import 'package:arogyam/bloc/app_effect.dart';
import 'package:arogyam/bloc/user/user_event.dart';
import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/data/user_repository.dart';
import 'package:arogyam/enums/snackbar_type.dart';
import 'package:arogyam/models/slot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState>
    with SideEffectProviderMixin<AppEffect> {
  final UserRepository _repository;

  String _loadingMessage(ManageSlotOperation operation) {
    return switch (operation) {
      ManageSlotOperation.create => "Scheduling your slot",
      ManageSlotOperation.update => "Re-Scheduling your slot",
      ManageSlotOperation.delete => "Cancelling your slot",
    };
  }

  UserBloc(this._repository) : super(const UserDetailsLoading()) {
    on<ManageSlotOperationEvent>((event, emit) async {
      try {
        emit(UserDetailsLoading(message: _loadingMessage(event.operation)));
        final message = await _repository.manageSlot(
          event.operation,
          event.slotId,
          oldSlotId: event.oldSlotId,
        );
        debugPrint("ManageSlotOperationEvent: $message");
        produceSideEffect(
          const SnackBarEffect(
            message: "Your slot was cancelled",
            type: SnackBarType.success,
          ),
        );
      } catch (err) {
        debugPrint("ManageSlotOperationEvent: $err");
        produceSideEffect(
          const SnackBarEffect(
            message: "Error cancelling your slot, try again later",
            type: SnackBarType.error,
          ),
        );
      } finally {
        add(const UserDetailsRequested());
      }
    });

    on<UserDetailsRequested>((event, emit) async {
      try {
        emit(const UserDetailsLoading());
        debugPrint('user slots requested refresh: ${event.refresh}');
        final List<Slot> slots = await _repository.fetchSlotList(
          refresh: event.refresh,
        );
        final isAdmin = await _repository.isAdmin();
        slots.sort((a, b) => b.getSlotId() - a.getSlotId());
        emit(UserDetailsLoaded(userSlotList: slots, isAdmin: isAdmin));
      } catch (err) {
        debugPrint('UserDetailsRequested: error $err');
        produceSideEffect(const SnackBarEffect(
          message: "error loading your details, try again later",
          type: SnackBarType.error,
        ));
      }
    });

    add(const UserDetailsRequested(refresh: true));
  }
}
