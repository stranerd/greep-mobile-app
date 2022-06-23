import 'package:flutter_bloc/flutter_bloc.dart';
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

  void signout() async {
    // set firebase token to null
    emit(AuthenticationStateLoading());
    await authenticationService.logout();
    Future.delayed(Duration(seconds: 1), () {
      emit(AuthenticationStateNotAuthenticated());
    });
  }
}
