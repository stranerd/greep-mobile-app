import 'package:bloc/bloc.dart';
import 'package:greep/domain/auth/AuthenticationService.dart';
import 'package:meta/meta.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final AuthenticationService authenticationService;

  EmailVerificationCubit({required this.authenticationService}) : super(EmailVerificationInitial());

  sendVerificationCode(String email) async {
    emit(EmailVerificationStateLoading());
    var response = await authenticationService.sendEmailVerificationCode(email);
    if (response.isError){
      emit(EmailVerificationStateError(errorMessage: response.errorMessage?? "An Error Occurred, try again"));

    }
    else {
      emit(EmailVerificationCodeSent());
    }
  }

  Future<String?> confirmVerificationCode({required String token}) async {
    emit(EmailVerificationStateLoading());
    var response = await authenticationService.confirmEmailVerificationCode(token: token);
    if (response.isError){
      emit(EmailVerificationStateError(errorMessage: response.errorMessage?? "An Error Occurred, try again"));
      return response.errorMessage ?? "Invalid or expired code";
    }
    else {
      emit(EmailVerificationSuccess());
      return null;
    }
  }
}
