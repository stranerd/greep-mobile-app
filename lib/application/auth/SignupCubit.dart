import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/AuthenticationState.dart';
import 'package:grip/application/auth/SignupState.dart';
import 'package:grip/application/auth/request/LoginRequest.dart';
import 'package:grip/application/auth/request/SignupRequest.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthenticationCubit authenticationCubit;
  late StreamSubscription _streamSubscription;
  final AuthenticationService authenticationService;

  SignupCubit({required this.authenticationCubit,required this.authenticationService}) : super(SignupStateUninitialized()) {
    _streamSubscription = authenticationCubit.stream.listen((state) {
      if (state is AuthenticationStateError) {
        emit(
          SignupStateError(
            state.errorMessage,
            isConnectionTimeout: state.isConnectionTimeout,
            isSocket: state.isSocket,
          ),
        );
      }
      if (state is AuthenticationStateAuthenticated) {
        emit(SignupStateSuccess());
      }
    });
  }

  void signUp(SignUpRequest request) async{
    emit(SignupStateLoading());
    authenticationCubit.signup(request);
  }

  void testSignup(LoginRequest request)async{
    emit(SignupStateLoading());
    var response = await authenticationService.testSignup(request);
    if (response.isError){
      emit(SignupStateError(response.errorMessage,fieldErrors: response.fieldErrors,isConnectionTimeout: response.isConnectionTimeout,
      isSocket: response.isSocket));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
