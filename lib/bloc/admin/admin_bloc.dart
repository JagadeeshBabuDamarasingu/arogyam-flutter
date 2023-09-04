import 'package:arogyam/bloc/app_bloc.dart';
import 'package:arogyam/bloc/app_effect.dart';
import 'package:arogyam/bloc/app_event.dart';
import 'package:arogyam/bloc/app_state.dart';
import 'package:arogyam/data/admin_repository.dart';
import 'package:arogyam/enums/snackbar_type.dart';
import 'package:arogyam/enums/vaccination_status.dart';
import 'package:arogyam/models/slot.dart';
import 'package:arogyam/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_event.dart';

part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState>
    with SideEffectProviderMixin<AppEffect> {
  final AdminRepository _repository;

  AdminBloc(this._repository)
      : super(const AdminState(userLoading: false, slotLoading: false)) {
    on<OnSlotDetailsRequested>((event, emit) async {
      try {
        emit(state.copyFrom(slotLoading: true));
        final slots = await _repository.fetchSlotsByDate(event.slotDate);
        slots.sort((a, b) => a.slotNumber - b.slotNumber);
        emit(state.copyFrom(slotList: slots, slotLoading: false));
      } catch (error) {
        debugPrint("error fetching users: $error");
        produceSideEffect(
          const SnackBarEffect(
            message: "error fetching slot details",
            type: SnackBarType.error,
          ),
        );
      }
    });

    on<OnUserDetailsRequested>((event, emit) async {
      try {
        emit(state.copyFrom(userLoading: true));
        final users = await _repository.fetchUserDetails(event.filters);
        emit(state.copyFrom(userLoading: false, userList: users));
      } catch (error, trace) {

        debugPrint("error fetching user: $error");
        debugPrintStack(stackTrace: trace);
        produceSideEffect(
          const SnackBarEffect(
            message: "error fetching user details",
            type: SnackBarType.error,
          ),
        );
      }
    });
  }
}
