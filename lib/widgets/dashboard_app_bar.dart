import 'package:flutter/cupertino.dart';

class DashboardAppBar extends ValueListenableBuilder<bool>
    implements PreferredSizeWidget {
  
  const DashboardAppBar({
    super.key,
    required super.valueListenable,
    required super.builder,
    required super.child
  });

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(preferredSize: Size.fromHeight(200), child: Text("Shiva"));
  }
}
