import 'package:arogyam/widgets/dashboard_filter_view.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _filterOpenNotifier = ValueNotifier(true);

  void _onFilterClicked() {
    _filterOpenNotifier.value = !_filterOpenNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 16,
        title: const Text("Dashboard"),
        bottom: DashboardFilterView(
          valueListenable: _filterOpenNotifier,
          builder: (context, value, child) {
            return Text("bool value is ${value}");
          },
        ),
        actions: [
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            onTap: _onFilterClicked,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.filter_alt_outlined),
            ),
          ),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
