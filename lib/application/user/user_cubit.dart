import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/AuthenticationState.dart';
import 'package:grip/domain/user/UserService.dart';
import 'package:grip/domain/user/model/User.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserService userService;
  final AuthenticationCubit authenticationCubit;
  late StreamSubscription _streamSubscription;
  late User user;
  String? userId;

  UserCubit({required this.authenticationCubit, required this.userService})
      : super(UserStateUninitialized()) {
    _streamSubscription = authenticationCubit.stream.listen((state) {
      if (state is AuthenticationStateAuthenticated) {
        userId = state.userId;
        fetchUser();
      }
    });
  }

  Future<User?> fetchUser() async {
    emit(UserStateLoading());
    var response = await userService.fetchUser(userId!);
    if (response.isError) {
      emit(UserStateError(response.errorMessage,
          isConnectionTimeout: response.isConnectionTimeout,
          isSocket: response.isSocket));
      return null;
    } else {
      if (response.data!.hasManager){
        getUserManager(response.data!.managerId??"");
      }
      user = response.data!;
      emit(UserStateFetched(user));
      return user;
    }
  }

  void getUserManager(String userId)async {
     userService.fetchUser(userId).then((value) {
    if (!value.isError){
      user.managerName = value.data!.fullName;
    }
    else {
      print("fetch user manager failed");
    }
  });

  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
