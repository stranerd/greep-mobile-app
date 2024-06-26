import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:greep/application/auth/AuthStore.dart';
import 'package:greep/application/auth/password/request/confirm_reset_pin_request.dart';
import 'package:greep/application/auth/password/request/create_transaction_pin_request.dart';
import 'package:greep/application/auth/request/AppleSigninRequest.dart';
import 'package:greep/application/auth/request/GoogleSigninRequest.dart';
import 'package:greep/application/auth/request/LoginRequest.dart';

import 'package:greep/application/auth/request/SignupRequest.dart';
import 'package:greep/application/auth/response/apple_signin_response.dart';
import 'package:greep/application/response.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'AuthenticationClient.dart';

class AuthenticationService {
  final AuthenticationClient authenticationClient;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  AuthenticationService({required this.authenticationClient});

  Future<ResponseEntity<Map<String, dynamic>>> login(
    LoginRequest request,
  ) async {
    var response = await authenticationClient.login(
      request,
    );
    if (!response.isError) {
      setToken(response.data!
        ..putIfAbsent("isGoogle", () => false)
        ..putIfAbsent("password", () => request.password)
        ..putIfAbsent("email", () => request.email));
    }

    return response;
  }

  Future<Map<String, dynamic>> checkAuthToken() async {
    return await AuthStore().getAuthToken();
  }

  Future<ResponseEntity> initiateGoogleSignin() async {
    auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final auth.AuthCredential credential =
            auth.GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await firebaseAuth.signInWithCredential(credential);

        var response = await authenticationClient.googleLogin(
            GoogleSigninRequest(
                accessToken: googleSignInAuthentication.accessToken ?? "",
                idToken: googleSignInAuthentication.idToken ?? ""));
        if (response.isError) {
          return ResponseEntity.Error(
              response.errorMessage ?? "An error occurred. Please try again");
        }

        setToken(response.data!
          ..putIfAbsent("idToken", () => googleSignInAuthentication.idToken)
          ..putIfAbsent(
              "accessToken", () => googleSignInAuthentication.accessToken)
          ..putIfAbsent("isGoogle", () => true));
        return response;
      } else {
        return ResponseEntity.Error("");
      }
    } on auth.FirebaseAuthException catch (e) {
      print(" fire base exception ${e.message}");
      return ResponseEntity.Error(e.message);
    } on PlatformException catch (e) {
      print("platform exception ${e.code}");

      return ResponseEntity.Error(e.code);
    } catch (e) {
      return ResponseEntity.Error("");
    }
  }

  Future<ResponseEntity<AppleSigninResponse>> initiateAppleSignin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.userIdentifier == null ||
          credential.userIdentifier!.isEmpty) {
        return ResponseEntity.Error("Could not sign in with Apple");
      }

      // print(
      //     "state: ${credential.state}, identifier: ${credential.userIdentifier}, email: ${credential.email}, idToken: ${credential.identityToken}, ${credential.givenName}, ${credential.authorizationCode} ");
      return ResponseEntity.Data(AppleSigninResponse(
          firstName: credential.givenName ?? "User",
          lastName: credential.familyName ?? "u${Random().nextInt(234)}",
          email: credential.email ?? "",
          identifier: credential.identityToken!));
    } catch (e) {
      return ResponseEntity.Error("Could not sign in with Apple");
    }
  }

  Future<ResponseEntity<Map<String, dynamic>>> appleSignin(
      AppleSigninResponse signInResponse) async {
    var response = await authenticationClient.appleSignin(AppleSigninRequest(
      email: signInResponse.email,
      idToken: signInResponse.identifier,
      firstName: signInResponse.firstName,
      lastName: signInResponse.lastName,
    ));
    if (response.isError) {
      googleSignIn.signOut();
    } else {
      setToken(response.data);
    }
    return response;
  }

  Future<bool> logout() async {
    var instance = await SharedPreferences.getInstance();
    instance.clear();
    instance.setBool("FirstRun", false);
    AuthStore().deleteToken();

    // remove all registered dependencies
    return true;
  }

  void googleSignout() async {
    googleSignIn.signOut();
  }

  Future<ResponseEntity> lightSignup(LoginRequest request) async {
    var response = await authenticationClient.testSignup(request);

    if (!response.isError) {
      setToken(response.data!
        ..putIfAbsent("isGoogle", () => false)
        ..putIfAbsent("password", () => request.password)
        ..putIfAbsent("email", () => request.email));
    }

    return response;
  }

  Future<ResponseEntity> verifyTransactionPin({required String pin}) async {
    var responseEntity = await authenticationClient.verifyTransactionPin(pin: pin);

    if (responseEntity.data == false){
      return ResponseEntity.Error("Transaction PIN incorrect");
    }
    return responseEntity;

  }
  Future<ResponseEntity> updateTransactionPin(
      UpdateTransactionPinRequest request,
      ) async {
    return await authenticationClient.updateTransactionPin(request);

  }

  Future<ResponseEntity> sendResetPINCode() async {
    return await authenticationClient.sendResetPINCode();

  }
  Future<ResponseEntity> confirmResetPIN(
      ConfirmResetPINRequest request,
      ) async {
    return await authenticationClient.confirmResetPIN(request);
  }

  Future<ResponseEntity<Map<String, dynamic>>> signup(
    SignUpRequest request,
  ) async {
    var response = await authenticationClient.signup(request);

    if (!response.isError) {
      setToken(response.data!
        ..putIfAbsent("isGoogle", () => false)
        ..putIfAbsent("password", () => request.password)
        ..putIfAbsent("email", () => request.email));
    }

    return response;
  }

  // Future<ResponseEntity> refreshToken() async {
  //   var pref = AuthStore();
  //   var token = await pref.getAuthToken();
  //   bool isGoogle = token["isGoogle"] ?? false;
  //   if (!isGoogle) {
  //     var response = await login(
  //         LoginRequest(password: token["password"], email: token["email"]));
  //     if (!response.isError) {
  //       setToken(response.data!..putIfAbsent("isGoogle", () => false));
  //     }
  //     return response;
  //   } else {
  //     var response = await authenticationClient.googleLogin(GoogleSigninRequest(
  //         accessToken: token["accessToken"] ?? "",
  //         idToken: token["idToken"] ?? ""));
  //     if (response.isError) {
  //       return ResponseEntity.Error(
  //           response.errorMessage ?? "An error occurred. Please try again");
  //     }
  //
  //     setToken(response.data!
  //       ..putIfAbsent("idToken", () => token["idToken"])
  //       ..putIfAbsent("accessToken", () => token["accessToken"])
  //       ..putIfAbsent("isGoogle", () => true));
  //     return response;
  //   }
  // }

  Future<ResponseEntity> refreshToken() async {
    var response = await authenticationClient.refreshToken();
    if (!response.isError) {
      setToken(response.data);
    }
    return response;
  }

  Future<ResponseEntity> testSignup(LoginRequest request) async {
    return await authenticationClient.testSignup(request);
  }

  void setToken(dynamic data) async {
    AuthStore().setToken(data);
  }

  Future<ResponseEntity> sendResetPasswordCode(String email) async {
    return await authenticationClient.sendResetPasswordCode(email);
  }

  Future<ResponseEntity> confirmPasswordResetChange(
      {required String password, required String token}) async {
    return await authenticationClient.confirmPasswordResetChange(
        password: password, token: token);
  }

  Future<ResponseEntity> sendEmailVerificationCode(String email) async{
    return await authenticationClient.sendEmailVerificationCode(email);
  }

  Future<ResponseEntity> confirmEmailVerificationCode({required String token}) async{
    return await authenticationClient.confirmEmailVerificationCode(token: token);
  }


  void subscribeToPush() async {
    var deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      authenticationClient.subscribeToPush(token: deviceToken);
    }
  }

}
