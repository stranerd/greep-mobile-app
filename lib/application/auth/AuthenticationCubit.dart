import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/AuthStore.dart';
import 'package:grip/application/auth/AuthenticationState.dart';
import 'package:grip/application/auth/request/LoginRequest.dart';
import 'package:grip/application/auth/request/SignupRequest.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';

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

  // Check if authentication is still valid on previous app usage
  Future<bool> checkAuth() async {
    print("checking auth");
    Map<String, dynamic> token = await authStore.getAuthToken();
    print(token);
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
          ),
        );
      }
    } catch (e) {
      emit(AuthenticationStateError("An error occurred. Please try again"));
    }
  }

  // void signupWithGoogle({required bool isClient, required User user, String? otp}) async {
  //   String fcm = await fcmToken();
  //   SignUpRequest request = SignUpRequest(
  //     referralIdentity: " ",
  //     password: user.uid,
  //     otp: otp??"",
  //     firebaseToken: fcm,
  //     isGoogleSignIn: true,
  //     fullName: user.displayName ?? "",
  //     email: user.email!,
  //   );
  //   signup(request, isClient, true);
  // }

  // void loginWithGoogle({required bool isClient, required User user}) async {
  //   String fcm = await fcmToken();
  //   LoginRequest request = LoginRequest(
  //       password: user.uid, email: user.email!, firebaseToken: fcm);
  //   login(request, isClient);
  // }

  void signout() async {
    // set firebase token to null
    emit(AuthenticationStateLoading());
    await authenticationService.logout();
    Future.delayed(Duration(seconds: 1), () {
      emit(AuthenticationStateNotAuthenticated());
    });
  }
}
