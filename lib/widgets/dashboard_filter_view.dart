import 'package:flutter/material.dart';

class DashboardFilterView extends ValueListenableBuilder<bool>
    implements PreferredSizeWidget {
  const DashboardFilterView({
    super.key,
    required super.valueListenable,
    required super.builder,
  });

  @override
  State<DashboardFilterView> createState() => _DashboardFilterViewState();

  @override
  Size get preferredSize => Size.fromHeight(valueListenable.value ? 400 : 0);
}

class _DashboardFilterViewState extends State<DashboardFilterView> {
  void _valueListener() {
    setState(() {});
  }

  @override
  void initState() {
    widget.valueListenable.addListener(_valueListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: widget.builder(context, widget.valueListenable.value, null),
    );
  }
}
