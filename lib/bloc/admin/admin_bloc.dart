import 'package:arogyam/bloc/app_event.dart';
import 'package:arogyam/bloc/app_state.dart';
import 'package:arogyam/models/slot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_event.dart';

part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(const SlotListLoading()) {
    on<OnSlotDetailsRequested>((event, emit) {});
  }
}
