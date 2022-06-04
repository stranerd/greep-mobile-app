import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:grip/application/auth/request/SignupRequest.dart';
import 'package:grip/application/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/auth/AuthStore.dart';
import '../../../application/auth/request/LoginRequest.dart';
import 'AuthenticationClient.dart';

class AuthenticationService {
  final AuthenticationClient authenticationClient;
  // final GoogleSignIn googleSignIn = GoogleSignIn();


  AuthenticationService({required this.authenticationClient});

  Future<ResponseEntity<Map<String, dynamic>>> login(
      LoginRequest request,) async {
    var response = await authenticationClient.login(request,);
    if (!response.isError) {
      setToken(response.data);
    }

    return response;
  }

  Future<Map<String, dynamic>> checkAuthToken() async {
    return await AuthStore().getAuthToken();
  }

  // Future<ResponseEntity<auth.User>> initiateGoogleSignin() async {
  //   print("signing with google");
  //   auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  //   auth.User user;
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //     await googleSignIn.signIn();
  //
  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;
  //
  //       final auth.AuthCredential credential = auth.GoogleAuthProvider
  //           .credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );
  //
  //       final auth.UserCredential userCredential =
  //       await firebaseAuth.signInWithCredential(credential);
  //
  //       user = userCredential.user!;
  //     } else {
  //       return ResponseEntity.Error("");
  //     }
  //   } on auth.FirebaseAuthException catch (e) {
  //     print(" fire base exception ${e.message}");
  //     return ResponseEntity.Error(e.message);
  //   } on PlatformException catch (e) {
  //     print("platform exception ${e.code}");
  //
  //     return ResponseEntity.Error(e.code);
  //   } catch (e) {
  //     return ResponseEntity.Error("");
  //   }
  //
  //   return ResponseEntity.Data(user);
  // }

  Future<bool> logout() async {
    var instance = await SharedPreferences.getInstance();
    instance.clear();
    instance.setBool("FirstRun", false);
    AuthStore().deleteToken();

    // remove all registered dependencies
    return true;
  }

  // void googleSignout() async {
  //   googleSignIn.signOut();
  // }

  Future<ResponseEntity<Map<String, dynamic>>> signup(
      SignUpRequest request,) async {
    var response = await authenticationClient.signup(request);

    if (!response.isError) {
      setToken(response.data);
    }

    return response;
  }

  Future<ResponseEntity> refreshToken()async{
    var response = await authenticationClient.refreshToken();
    if (!response.isError){
      setToken(response.data);
    }
    return response;
  }

  void setToken(dynamic data) async {
    AuthStore().setToken(data);
  }
}
