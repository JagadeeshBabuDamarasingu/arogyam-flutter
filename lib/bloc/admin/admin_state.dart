part of 'admin_bloc.dart';

class AdminState extends AppState {
  final bool slotLoading;
  final bool userLoading;
  final List<Slot>? slotList;
  final List<User>? userList;

  @override
  List<Object?> get props => [
        slotLoading,
        userLoading,
        slotList,
        userList,
      ];

  const AdminState({
    this.slotLoading = false,
    this.userLoading = false,
    this.slotList,
    this.userList,
  });

  copyFrom({
    bool? slotLoading,
    bool? userLoading,
    List<Slot>? slotList,
    List<User>? userList,
  }) {
    return AdminState(
      slotLoading: slotLoading ?? this.slotLoading,
      userLoading: userLoading ?? this.userLoading,
      slotList: slotList ?? this.slotList,
      userList: userList ?? this.userList,
    );
  }
}
