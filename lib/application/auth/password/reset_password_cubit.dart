import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/auth/password/request/confirm_reset_pin_request.dart';
import 'package:greep/application/auth/password/request/create_transaction_pin_request.dart';
import 'package:greep/application/user/auth_user_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/wallet/user_wallet_cubit.dart';
import 'package:greep/domain/auth/AuthenticationService.dart';
import 'package:greep/ioc.dart';

part 'reset_password_state.dart';

class PasswordCrudCubit extends Cubit<PasswordCrudState> {
  final AuthenticationService authenticationService;

  PasswordCrudCubit({required this.authenticationService}) : super(PasswordCrudInitial());

  sendPINResetCode() async {
    emit(PasswordCrudStateLoading());
    var response = await authenticationService.sendResetPINCode();
    if (response.isError){
      emit(PasswordCrudStateError(errorMessage: response.errorMessage?? "An Error Occurred, try again"));

    }
    else {
      emit(PasswordCrudStateCodeSent());
    }
  }
  sendResetCode(String email) async {
    emit(PasswordCrudStateLoading());
    var response = await authenticationService.sendResetPasswordCode(email);
    if (response.isError){
      emit(PasswordCrudStateError(errorMessage: response.errorMessage?? "An Error Occurred, try again"));

    }
    else {
      emit(PasswordCrudStateCodeSent());
    }
  }

  void updateTransactionPin(UpdateTransactionPinRequest request) async{
    emit(PasswordCrudStateLoading());
    var response = await authenticationService.updateTransactionPin(request);
    if (response.isError){
      emit(PasswordCrudStateError(errorMessage: response.errorMessage?? "An Error Occurred, try again"));

    }
    else {
      emit(PasswordCrudStateSuccess());
    }

    getIt<UserWalletCubit>().fetchUserWallet(softUpdate: true);
    getIt<UserCubit>().fetchUser();
  }

  void confirmResetPIN(ConfirmResetPINRequest request) async{
    emit(PasswordCrudStateLoading());
    var response = await authenticationService.confirmResetPIN(request);
    if (response.isError){
      emit(PasswordCrudStateError(errorMessage: response.errorMessage?? "An Error Occurred, try again"));

    }
    else {
      emit(PasswordCrudStateSuccess());
    }

    getIt<UserWalletCubit>().fetchUserWallet(softUpdate: true);
    getIt<UserCubit>().fetchUser(softUpdate: true);
    getIt<AuthUserCubit>().fetchUser(softUpdate: true);

  }
  void verifyTransactionPin({required String pin,}) async {
    emit(PasswordCrudStateLoading());
    var response = await authenticationService.verifyTransactionPin(pin:pin,);
    if (response.isError){
      emit(PasswordCrudStateError(errorMessage: response.errorMessage?? "An Error Occurred, try again"));

    }
    else {
      emit(PasswordCrudStateSuccess());
    }
  }

  confirmResetPasswordChange({required String password, required String token}) async {
    emit(PasswordCrudStateLoading());
    var response = await authenticationService.confirmPasswordResetChange(password:password,token: token);
    if (response.isError){
      emit(PasswordCrudStateError(errorMessage: response.errorMessage?? "An Error Occurred, try again"));

    }
    else {
      emit(PasswordCrudStateSuccess());
    }
  }
}
