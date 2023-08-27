import 'package:flutter/material.dart';

extension RouteExtensions on BuildContext {
  openRoute(final Widget widget) {
    final route = MaterialPageRoute(builder: (context) => widget);
    Navigator.push(this, route);
  }
}
