part of 'user_wallet_cubit.dart';

@immutable
abstract class UserWalletState {}

class UserWalletStateInitial extends UserWalletState {}


class UserWalletStateFetched extends UserWalletState {

  final Wallet wallet;

  UserWalletStateFetched({required this.wallet});

  Map<String, dynamic> toMap() {
    return {
      'wallet': this.wallet,
    };
  }

  factory UserWalletStateFetched.fromMap(Map<String, dynamic> map) {
    return UserWalletStateFetched(
      wallet: map['wallet'] as Wallet,
    );
  }
}

class UserWalletStateLoading extends UserWalletState {}

class UserWalletStateError extends UserWalletState {

  final String? errorMessage;
  final bool isConnectionTimeout;
  final bool isSocket;
  final int statusCode;

  UserWalletStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false, required this.statusCode});

}
