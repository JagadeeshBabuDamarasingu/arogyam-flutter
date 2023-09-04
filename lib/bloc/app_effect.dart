import 'package:arogyam/enums/snackbar_type.dart';
import 'package:equatable/equatable.dart';

abstract class AppEffect extends Equatable {
  const AppEffect();

  @override
  List<Object?> get props => [];
}

class NavigateEffect extends AppEffect {
  final String routeName;
  final Map<String, dynamic>? arguments;

  const NavigateEffect({
    required this.routeName,
    this.arguments,
  });
}

class SnackBarEffect extends AppEffect {
  final SnackBarType type;
  final String message;

  const SnackBarEffect({
    required this.message,
    this.type = SnackBarType.info,
  });
}

class ShowDialogEffect extends AppEffect {}
