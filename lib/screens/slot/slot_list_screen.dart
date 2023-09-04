import 'package:arogyam/bloc/slots/slot_event.dart';
import 'package:arogyam/bloc/slots/slot_list_bloc.dart';
import 'package:arogyam/bloc/slots/slot_state.dart';
import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/extensions/snackbar_extensions.dart';
import 'package:arogyam/models/slot.dart';
import 'package:arogyam/widgets/slot_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SlotListScreen extends StatefulWidget {
  const SlotListScreen({super.key});

  @override
  State<SlotListScreen> createState() => _SlotListScreenState();
}

class _SlotListScreenState extends State<SlotListScreen> {
  late var args = <String, dynamic>{};
  late final String slotDate = args['date'];
  late final bool isEditMode = args['oldSlotDate'] != null;
  late final localizations = MaterialLocalizations.of(context);

  final _selectedSlotNotifier = ValueNotifier<Slot?>(null);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    context.read<SlotListBloc>().add(OnSlotListRequested(slotDate: slotDate));
  }

  String _formatDate(String date) {
    return localizations.formatMediumDate(
      DateTime(
        int.parse(date.substring(0, 4)),
        int.parse(date.substring(4, 6)),
        int.parse(date.substring(6, 8)),
      ),
    );
  }

  void _bookSlot() {
    final bookedSlot = _selectedSlotNotifier.value;
    if (bookedSlot == null) {
      context.showSnackBar("Please select a slot");
      return;
    }

    context.read<SlotListBloc>().add(
          ManageSlotOperationEvent(
            operation: isEditMode
                ? ManageSlotOperation.update
                : ManageSlotOperation.create,
            slotId: bookedSlot.getSlotId().toString(),
            oldSlotId: args['oldSlotDate'],
          ),
        );
  }

  Widget _renderSlotView(Slot slot) {
    bool isSelected =
        slot.slotNumber == _selectedSlotNotifier.value?.slotNumber;
    return AbsorbPointer(
      absorbing: slot.isFull(),
      child: SlotView(
        slot: slot,
        isSelected: isSelected,
        onTap: () {
          _selectedSlotNotifier.value = slot;
          debugPrint("slot selected! ${slot.getSlotId()}");
        },
      ),
    );
  }

  _renderLoadingProgressIndicator({String? message}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 12),
          if (message != null) Text(message, style: GoogleFonts.raleway())
        ],
      ),
    );
  }

  _renderSlotList(List<Slot> slotList) {
    return SingleChildScrollView(
      child: ValueListenableBuilder(
        valueListenable: _selectedSlotNotifier,
        builder: (context, value, child) {
          return Column(
            children: slotList.map(_renderSlotView).toList(growable: false),
          );
        },
      ),
    );
  }

  _renderSlotOperation(String response) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.done_all, size: 36),
          Text(response, style: GoogleFonts.raleway())
        ],
      ),
    );
  }

  _renderBody(SlotState state) {
    return switch (state) {
      SlotListLoading() => _renderLoadingProgressIndicator(
          message: "Loading slot details, please wait",
        ),
      SlotListLoaded() => _renderSlotList(state.slotList),
      OnManageSlotResponse() => _renderSlotOperation(state.message),
      ManageSlotLoading() => _renderLoadingProgressIndicator(
          message: state.message,
        ),
    };
  }

  _renderBookSlotButton() {
    return [
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: _bookSlot,
        child: Text(isEditMode ? "RESCHEDULE" : "SCHEDULE"),
      ),
      const SizedBox(width: 12)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 16,
        title: Text(_formatDate(slotDate)),
        actions: _renderBookSlotButton(),
      ),
      body: SafeArea(
        child: BlocBuilder<SlotListBloc, SlotState>(
          builder: (context, state) => _renderBody(state),
        ),
      ),
    );
  }
}
