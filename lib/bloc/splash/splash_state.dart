part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends SplashState{}

class OnInitialized extends SplashState {
  final bool isLoggedIn;

  OnInitialized({required this.isLoggedIn});

  @override
  List<Object?> get props => [isLoggedIn];
}
