import 'package:arogyam/bloc/user/user_event.dart';
import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/data/user_repository.dart';
import 'package:arogyam/models/slot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  UserBloc(this._repository) : super(const UserDetailsLoading()) {
    on<ManageSlotOperationEvent>((event, emit) async {
      emit(UserDetailsLoading(
        message: "${event.operation.name.toString().toLowerCase()}ing your slot",
      ));
      final message = await _repository.manageSlot(
        event.operation,
        event.slotId,
        oldSlotId: event.oldSlotId,
      );
      debugPrint("ManageSlotOperationEvent: $message");
      add(const UserDetailsRequested());
    });

    on<UserDetailsRequested>((event, emit) async {
      emit(const UserDetailsLoading());
      debugPrint('user slots requested!');
      final List<Slot> slots =
          await _repository.fetchSlotList(refresh: event.refresh);
      final isAdmin = await _repository.isAdmin();
      slots.sort((a, b) => b.getSlotId() - a.getSlotId());
      emit(UserDetailsLoaded(userSlotList: slots, isAdmin: isAdmin));
    });

    add(const UserDetailsRequested(refresh: true));
  }
}
