import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/auth/AuthStore.dart';
import 'package:greep/application/auth/AuthenticationState.dart';
import 'package:greep/application/auth/request/LoginRequest.dart';
import 'package:greep/application/auth/request/SignupRequest.dart';
import 'package:greep/domain/auth/AuthenticationService.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationService authenticationService;
  AuthStore authStore = AuthStore();
  String? userId;

  AuthenticationCubit(this.authenticationService)
      : super(AuthenticationStateUninitialized());

  Future<void> login(LoginRequest request, [bool isGoogle = false]) async {
    emit(AuthenticationStateLoading(isGoogle: isGoogle));
    var response = await authenticationService.login(request);

    if (response.isError) {
      emit(AuthenticationStateError(response.errorMessage ?? "login failed",
          isConnectionTimeout: response.isConnectionTimeout,
          isSocket: response.isSocket));
    } else {
      userId = response.data!["id"]!;
      emit(
        AuthenticationStateAuthenticated(
          token: response.data!["token"]!,
          userId: response.data!["id"]!,
        ),
      );
    }
  }

  void signinWithGoogle()async{
    var response = await authenticationService.initiateGoogleSignin();
    if (response.isError){
      emit(AuthenticationStateError(response.errorMessage??""));

    }
    else {
      emit(AuthenticationStateAuthenticated(token: response.data["token"], userId: response.data["id"]));
    }
  }

  void loginWithApple() async {
    var response = await authenticationService.initiateAppleSignin();
    if (response.isError) {
      print("initiation error");
      emit(AuthenticationStateError(response.errorMessage!,
          isConnectionTimeout: response.isConnectionTimeout,
          isSocket: response.isSocket));
    } else {
      print("initiation success");
      emit(AuthenticationStateLoading());
      var response2 = await authenticationService.appleSignin(response.data!);
      if (response2.isError) {
        emit(AuthenticationStateError(response2.errorMessage!,
            isConnectionTimeout: response.isConnectionTimeout,
            isSocket: response.isSocket));
      } else {
        emit(AuthenticationStateAuthenticated(token: response2.data?['token']??"", userId: response2.data?["id"]??""));
      }
    }
  }

  // Check if authentication is still valid on previous app usage
  Future<bool> checkAuth() async {
    Map<String, dynamic> token = await authStore.getAuthToken();
    if (token.isNotEmpty) {
      userId = token["id"]!;
      emit(AuthenticationStateAuthenticated(
          token: token["token"]!,
          userId: token["id"]!,));
      return true;
    } else {
      emit(AuthenticationStateNotAuthenticated());

      return false;
    }
  }

  Future<void> signup(SignUpRequest request, [bool isGoogle = false]) async {
    emit(AuthenticationStateLoading(isGoogle: isGoogle));
    try {
      var response =
          await authenticationService.signup(request);
      if (response.isError) {
        emit(
          AuthenticationStateError(response.errorMessage ?? "Signup failed",
              fieldErrors: response.fieldErrors,
              isConnectionTimeout: response.isConnectionTimeout,
              isSocket: response.isSocket),
        );
        return;
      } else {
        userId = response.data!["id"];
        emit(
          AuthenticationStateAuthenticated(
              token: response.data!["token"]!,
              userId: response.data!["id"]!,
            isSignup: true
          ),
        );
      }
    } catch (e) {
      emit(AuthenticationStateError("An error occurred. Please try again"));
    }
  }

  void signout() async {
    // set firebase token to null
    emit(AuthenticationStateLoading());
    await authenticationService.logout();
    authenticationService.googleSignout();

    Future.delayed(Duration(seconds: 1), () {
      emit(AuthenticationStateNotAuthenticated());
    });
  }
}
