import 'package:bloc/bloc.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';
import 'package:meta/meta.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthenticationService authenticationService;

  ResetPasswordCubit({required this.authenticationService}) : super(ResetPasswordInitial());

  sendResetCode(String email) async {
    emit(ResetPasswordStateLoading());
    var response = await authenticationService.sendResetPasswordCode(email);
    if (response.isError){
      emit(ResetPasswordStateError(errorMessage: response.errorMessage?? "An Error Occurred, try again"));

    }
    else {
      emit(ResetPasswordCodeSent());
    }
  }

  confirmResetPasswordChange({required String password, required String token}) async {
    emit(ResetPasswordStateLoading());
    var response = await authenticationService.confirmPasswordResetChange(password:password,token: token);
    if (response.isError){
      emit(ResetPasswordStateError(errorMessage: response.errorMessage?? "An Error Occurred, try again"));

    }
    else {
      emit(ResetPasswordSuccess());
    }
  }
}
