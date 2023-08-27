import 'package:flutter/material.dart';

enum SnackBarType {
  info(Colors.black),
  success(Colors.green),
  error(Colors.red);

  final Color bgColor;

  const SnackBarType(this.bgColor);
}
