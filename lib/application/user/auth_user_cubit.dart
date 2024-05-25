import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/application/auth/AuthenticationState.dart';
import 'package:greep/domain/firebase/Firebase_service.dart';
import 'package:greep/domain/user/UserService.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/domain/user/model/auth_user.dart';

part 'auth_user_state.dart';

class AuthUserCubit extends Cubit<AuthUserState> {
  final UserService userService;
  final AuthenticationCubit authenticationCubit;
  late StreamSubscription _streamSubscription;
  late AuthUser user;
  String? userId;

  AuthUserCubit({
    required this.authenticationCubit,
    required this.userService,
  }) : super(AuthUserStateUninitialized()) {
    _streamSubscription = authenticationCubit.stream.listen((state) {
      if (state is AuthenticationStateAuthenticated) {
        userId = state.userId;

        fetchUser();
      }
    });
  }

  Future<AuthUser?> fetchUser({
    bool softUpdate = false,
  }) async {
    if (!softUpdate) {
      emit(AuthUserStateLoading());
    }
    var response = await userService.fetchAuthUser(userId!);
    if (response.isError) {
      emit(AuthUserStateError(response.errorMessage,
          isConnectionTimeout: response.isConnectionTimeout,
          isSocket: response.isSocket));
      return null;
    } else {
      user = response.data!;
      emit(AuthUserStateFetched(user));
      authenticationCubit.subscribeToPush();
      FirebaseApi.signInWithFirebase();

      return user;
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
