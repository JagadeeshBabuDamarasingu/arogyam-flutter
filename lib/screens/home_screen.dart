import 'dart:async';

import 'package:arogyam/app/LifeCycleObserver.dart';
import 'package:arogyam/app/app_routes.dart';
import 'package:arogyam/bloc/app_effect.dart';
import 'package:arogyam/bloc/user/user_bloc.dart';
import 'package:arogyam/bloc/user/user_event.dart';
import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/enums/snackbar_type.dart';
import 'package:arogyam/extensions/snackbar_extensions.dart';
import 'package:arogyam/models/slot.dart';
import 'package:arogyam/widgets/book_slot_view.dart';
import 'package:arogyam/widgets/title_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<AppEffect> _subscription;
  late final localizations = MaterialLocalizations.of(context);
  late final userBloc = context.read<UserBloc>();

  @override
  void initState() {
    super.initState();
    _subscription = userBloc.effectStream.listen(_handleError);
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          debugPrint("Home: resumeCallBack");
          return userBloc.add(const UserDetailsRequested());
        },
      ),
    );
  }

  void _handleError(AppEffect effect) {
    if (effect is SnackBarEffect) {
      context.showSnackBar(
        effect.message,
        type: effect.type,
      );
    }
  }

  @override
  void dispose() async {
    await _subscription.cancel();
    super.dispose();
  }

  void _switchToAdminView() {
    Navigator.of(context).pushNamed(AppRoutes.adminHome);
  }

  void _openSlotListScreen(DateTime slotDate, {String? oldSlotDate}) {
    final year = slotDate.year.toString().padLeft(4, '0');
    final month = slotDate.month.toString().padLeft(2, '0');
    final day = slotDate.day.toString().padLeft(2, '0');
    Navigator.pushNamed(
      context,
      AppRoutes.slotListScreen,
      arguments: {'date': '$year$month$day', 'oldSlotDate': oldSlotDate},
    ).then((value) => userBloc.add(const UserDetailsRequested()));
  }

  void _onBookSlotClicked({String? oldSlotId}) async {
    final dateSelected = await showDatePicker(
      context: context,
      confirmText: "BOOK",
      cancelText: "CANCEL",
      helpText:
          oldSlotId == null ? "Start by select a slot date" : "Edit your slot",
      currentDate: DateTime.timestamp(),
      firstDate: DateTime(2023, 11),
      initialDate: DateTime(2023, 11),
      lastDate: DateTime(2023, 11, 30),
    );

    if (dateSelected != null) {
      _openSlotListScreen(dateSelected, oldSlotDate: oldSlotId);
    }
  }

  _renderSwitchToAdminButton(UserState state) {
    return switch (state) {
      UserDetailsLoading() => <Widget>[],
      UserDetailsLoaded(isAdmin: var admin) when !admin => <Widget>[],
      _ => [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: InkWell(
              onTap: _switchToAdminView,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text("Switch to Admin"),
              ),
            ),
          ),
          const SizedBox(width: 12)
        ]
    };
  }

  _getTitleByIndex(int index) {
    return switch (index) {
      1 => 'First Dose of Vaccination',
      2 => 'Second Dose of Vaccination',
      _ => '$index of vaccination'
    };
  }

  _formatSlotDate(DateTime slotDate) {
    return localizations.formatCompactDate(slotDate);
  }

  _openGMapLink() async {
    final uri = Uri.parse(
        "https://www.google.com/maps/place/Ghmc+Covid+Vaccination/@17.4461673,78.5667402,17z/data=!3m1!4b1!4m6!3m5!1s0x3bcb9c08caf39d13:0x1eb4edb464ebe904!8m2!3d17.4461674!4d78.5716111!16s%2Fg%2F11tbwnjsb5?entry=ttu");

    try {
      await launchUrl(uri);
    } catch (err) {
      debugPrint("error launching gmaps: $err");
      // ignore: use_build_context_synchronously
      context.showSnackBar(
        "Error launching google maps, try again later",
        type: SnackBarType.error,
      );
    }
  }

  void _cancelSlot(Slot slot) async {
    await showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cancel Slot'),
            content: Text(
              "Are you sure, you want to cancel this slot on ${_formatSlotDate(slot.getStartTime())} ?",
            ),
            actions: [
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('NO'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  userBloc.add(
                    ManageSlotOperationEvent(
                      operation: ManageSlotOperation.delete,
                      slotId: slot.getSlotId().toString(),
                    ),
                  );
                },
                child: const Text('YES'),
              )
            ],
          );
        });
  }

  Widget _renderEditOptions(Slot slot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonTheme(
          minWidth: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.edit_calendar_outlined),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _onBookSlotClicked(
              oldSlotId: slot.getSlotId().toString(),
            ),
            label: Text(
              "RESCHEDULE",
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ButtonTheme(
          minWidth: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _cancelSlot(slot),
            label: Text(
              "CANCEL",
              style: GoogleFonts.raleway(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _renderSlot(Slot slot, int index) {
    return Card(
      key: ValueKey(slot.getSlotId()),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.purple[100]!,
            Colors.purple[50]!,
          ]),
          color: slot.isElapsed() ? Colors.grey : Colors.white,
          // border: Border.all(color: Colors.deepOrange),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(16),
        // margin: const EdgeInsets.symmetric(vertical: 8),
        child: AbsorbPointer(
          absorbing: slot.isElapsed(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getTitleByIndex(index + 1),
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text('on ${_formatSlotDate(slot.getStartTime())}'),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text('at your District COVID care center'),
                  const Spacer(),
                  InkWell(
                    onTap: _openGMapLink,
                    child: const Icon(Icons.directions),
                  )
                ],
              ),
              const SizedBox(height: 6),
              if (slot.isEditable()) _renderEditOptions(slot)
            ],
          ),
        ),
      ),
    );
  }

  _renderSlotList(List<Slot> slots) {
    final slotWidgets = <Widget>[];
    slots.sort((a, b) => b.getSlotId() - a.getSlotId());
    final slotListSize = slots.length;
    for (int i = 0; i < slotListSize; i++) {
      slotWidgets.add(_renderSlot(slots[i], slotListSize - i - 1));
    }

    if (slots.isEmpty || slots.first.isElapsed()) {
      slotWidgets.add(BookSlotView(
        onPressed: _onBookSlotClicked,
        noOfDosesTook: slots.length,
      ));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(children: slotWidgets),
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

  _renderUserSlotList(slotList) {
    return RefreshIndicator(
      onRefresh: () async =>
          userBloc.add(const UserDetailsRequested(refresh: true)),
      child: _renderSlotList(slotList),
    );
  }

  _renderBody(UserState state) {
    return switch (state) {
      UserDetailsLoading() => _renderLoadingProgressIndicator(
          message: state.message,
        ),
      UserDetailsLoaded() => _renderUserSlotList(
          state.userSlotList,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      debugPrint("user state is ${state.toString()}");
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 16,
          title: const TitleView(),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple[50]!,
                    Colors.purple[100]!,
                  ],
                ),
              ),
            ),
          ),
          actions: _renderSwitchToAdminButton(state),
        ),
        body: SafeArea(child: _renderBody(state)),
      );
    });
  }
}
