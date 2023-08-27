import 'package:arogyam/app/LifeCycleObserver.dart';
import 'package:arogyam/app/app_routes.dart';
import 'package:arogyam/bloc/user/user_bloc.dart';
import 'package:arogyam/bloc/user/user_event.dart';
import 'package:arogyam/bloc/user/user_state.dart';
import 'package:arogyam/models/slot.dart';
import 'package:arogyam/res/strings.dart';
import 'package:arogyam/screens/admin/admin_dashboard_screen.dart';
import 'package:arogyam/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final localizations = MaterialLocalizations.of(context);
  late final userBloc = context.read<UserBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          debugPrint("Home: resumeCallBack");
          return userBloc.add(const UserDetailsRequested(refresh: true));
        },
      ),
    );
  }

  void _switchToAdminView() {
    final newRoute = MaterialPageRoute(
      builder: (context) => const AdminDashboardScreen(),
    );
    Navigator.of(context).push(newRoute);
  }

  void _openSlotListScreen(DateTime slotDate, {String? oldSlotDate}) {
    final year = slotDate.year.toString().padLeft(4, '0');
    final month = slotDate.month.toString().padLeft(2, '0');
    final day = slotDate.day.toString().padLeft(2, '0');
    Navigator.pushNamed(
      context,
      AppRoutes.slotListScreen,
      arguments: {'date': '$year$month$day', 'oldSlotDate': oldSlotDate},
    ).then((value) => userBloc.add(const UserDetailsRequested(refresh: true)));
  }

  void _onBookSlotClicked({String? oldSlotId}) async {
    final dateSelected = await showDatePicker(
      context: context,
      confirmText: "Book",
      helpText: "Select a slot date",
      currentDate: DateTime.timestamp(),
      firstDate: DateTime(2023, 11),
      initialDate: DateTime(2023, 11),
      lastDate: DateTime(2023, 11, 30),
    );

    if (dateSelected != null) {
      _openSlotListScreen(dateSelected, oldSlotDate: oldSlotId);
    }
  }

  _renderNoSlotsView() => const Center(
        child: Text("You have no slots booked! \n Start by booking a slot"),
      );

  _renderTitle() => GradientText(
        text: appName.toUpperCase(),
        textStyle: GoogleFonts.raleway(fontWeight: FontWeight.w500),
        gradientColors: [
          Colors.blueGrey[600]!,
          Colors.blueGrey,
          Colors.green,
          Colors.lightGreen,
          Colors.greenAccent,
        ],
      );

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

  _renderFAB(UserState state) {
    return switch (state) {
      UserDetailsLoading() => null,
      UserDetailsLoaded(userSlotList: var list)
          when (list.isNotEmpty && !list.first.isElapsed()) =>
        null,
      _ => FloatingActionButton.extended(
          onPressed: _onBookSlotClicked,
          isExtended: true,
          label: const Text("Book a Slot"),
        ),
    };
  }

  _getTitleByIndex(int index) {
    return switch (index) {
      1 => 'First Dose Vaccination',
      2 => 'Second Dose Vaccination',
      _ => '$index vaccination'
    };
  }

  _formatSlotDate(DateTime slotDate) {
    return localizations.formatCompactDate(slotDate);
  }

  void _cancelSlot(Slot slot) async {
    await showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cancel Slot'),
            content: Text(
                "Are you sure, you want to cancel this slot on ${_formatSlotDate(slot.getStartTime())} ?"),
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

  List<Widget> _renderEditOptions(Slot slot) {
    if (!slot.isEditable()) return [];
    return [
      InkWell(
        onTap: () => _onBookSlotClicked(oldSlotId: slot.getSlotId().toString()),
        child: const Icon(Icons.edit),
      ),
      InkWell(
        onTap: () => _cancelSlot(slot),
        child: const Icon(
          Icons.delete,
          color: Colors.redAccent,
        ),
      )
    ];
  }

  Widget _renderSlot(Slot slot, int index) {
    return Container(
      key: ValueKey(index),
      width: double.infinity,
      decoration: BoxDecoration(
        color: slot.isElapsed() ? Colors.grey : Colors.white,
        border: Border.all(color: Colors.deepOrange),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: AbsorbPointer(
        absorbing: slot.isElapsed(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(_getTitleByIndex(index + 1)),
                const Spacer(),
                ..._renderEditOptions(slot),
              ],
            ),
            const SizedBox(height: 4),
            Text('on ${_formatSlotDate(slot.getStartTime())}'),
            const SizedBox(height: 4),
            const Row(
              children: [
                Text('at your District COVID care center'),
                Spacer(),
                Icon(Icons.directions)
              ],
            )
          ],
        ),
      ),
    );
  }

  _renderSlotList(List<Slot> slots) {
    if (slots.isEmpty) return _renderNoSlotsView();
    final slotWidgets = <Widget>[];
    final slotListSize = slots.length;
    for (int i = 0; i < slotListSize; i++) {
      slotWidgets.add(_renderSlot(slots[i], slotListSize - i - 1));
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
      UserDetailsLoading() =>
        _renderLoadingProgressIndicator(message: state.message),
      UserDetailsLoaded() => _renderUserSlotList(state.userSlotList),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      debugPrint("user state is ${state.toString()}");
      return Scaffold(
        appBar: AppBar(
          elevation: 16,
          title: _renderTitle(),
          actions: _renderSwitchToAdminButton(state),
        ),
        floatingActionButton: _renderFAB(state),
        body: SafeArea(child: _renderBody(state)),
      );
    });
  }
}
