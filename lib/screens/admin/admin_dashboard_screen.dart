import 'package:arogyam/bloc/admin/admin_bloc.dart';
import 'package:arogyam/bloc/user/user_event.dart';
import 'package:arogyam/models/slot.dart';
import 'package:arogyam/models/user.dart';
import 'package:arogyam/validators/validators.dart';
import 'package:arogyam/widgets/dashboard_filter_view.dart';
import 'package:arogyam/widgets/slot_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late final adminBloc = context.read<AdminBloc>();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> filters = {};

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

  Widget _renderUserView(User user) {
    return Card(
      key: ValueKey(user.aadharNo),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.purple[100]!,
            Colors.purple[50]!,
          ]),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user.name}',
              style: GoogleFonts.raleway(),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Age: ${user.age}',
              style: GoogleFonts.raleway(),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Aadhar: ${user.getAadhar(masked: true, format: true)}',
              style: GoogleFonts.raleway(),
            ),
          ],
        ),
      ),
    );
  }

  _onApplyFilterClicked() {
    Navigator.pop(context);

    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      adminBloc.add(OnUserDetailsRequested(filters: filters));
    }
  }

  _renderFilterAction() {
    return [
      MaterialButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('CANCEL'),
      ),
      MaterialButton(
        onPressed: _onApplyFilterClicked,
        child: const Text('APPLY'),
      ),
    ];
  }

  _renderFilterBody() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Apply Filters'),
            const SizedBox(height: 16),
            TextFormField(
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  filters['aadhar'] = int.parse(value);
                } else {
                  filters.remove('aadhar');
                }
              },
              decoration: const InputDecoration(labelText: 'Aadhar Number'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  filters['age'] = value;
                } else {
                  filters.remove('age');
                }
              },
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  filters['pincode'] = value;
                } else {
                  filters.remove('pincode');
                }
              },
              decoration: const InputDecoration(labelText: 'Pin Code'),
            ),
          ],
        ),
      ),
    );
  }

  _onFilterUserClicked() async {
    filters.clear();
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: _renderFilterAction(),
          content: _renderFilterBody(),
        );
      },
    );
  }

  _renderUserListView() {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFilterUserClicked,
        label: const Text('Filter'),
        icon: const Icon(Icons.filter_alt_outlined),
      ),
      body: BlocBuilder<AdminBloc, AdminState>(builder: (context, state) {
        if (state.userLoading) {
          return _renderLoadingProgressIndicator(
            message: 'User details are loading, please wait',
          );
        }
        if (state.userList == null || state.userList?.isEmpty == true) {
          return const Center(
            child: Text('Users matching filters are empty'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: state.userList!
                .map((e) => _renderUserView(e))
                .toList(growable: false),
          ),
        );
      }),
    );
  }

  _onFilterSlotClicked() async {
    final dateSelected = await showDatePicker(
      context: context,
      confirmText: "BOOK",
      cancelText: "CANCEL",
      helpText: 'select a date',
      currentDate: DateTime.timestamp(),
      firstDate: DateTime(2023, 11),
      initialDate: DateTime(2023, 11),
      lastDate: DateTime(2023, 11, 30),
    );

    if (dateSelected != null) {
      final year = dateSelected.year.toString().padLeft(4, '0');
      final month = dateSelected.month.toString().padLeft(2, '0');
      final day = dateSelected.day.toString().padLeft(2, '0');
      adminBloc.add(OnSlotDetailsRequested(slotDate: '$year$month$day'));
    }
  }

  _renderSlotListView() {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFilterSlotClicked,
        label: const Text('Select Date'),
        icon: const Icon(Icons.filter_alt_outlined),
      ),
      body: BlocBuilder<AdminBloc, AdminState>(builder: (context, state) {
        if (state.slotLoading) {
          return _renderLoadingProgressIndicator(
            message: 'Slots are loading, please wait',
          );
        }
        if (state.slotList == null || state.slotList?.isEmpty == true) {
          return const Center(
            child: Text('Slots for selected date are empty'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: state.slotList!
                .map((e) => SlotView(slot: e))
                .toList(growable: false),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 16,
          title: const Text("Dashboard"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Slots'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _renderUserListView(),
              _renderSlotListView(),
            ],
          ),
        ),
      ),
    );
  }
}
