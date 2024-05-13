part of 'wallet_crud_cubit.dart';

@immutable
abstract class WalletCrudState {}

class WalletCrudStateInitial extends WalletCrudState {}
class WalletCrudStateLoading extends WalletCrudState {}

// class WalletCrudStateInitialized extends WalletCrudState {
//
//   final UserTransaction response;
//
//   WalletCrudStateInitialized({required this.response});
//
//
// }

class WalletCrudStateSuccess extends WalletCrudState {}
class WalletCrudStateWithdrawSuccess extends WalletCrudState {
  final WalletTransaction transaction;

  WalletCrudStateWithdrawSuccess({required this.transaction});

  Map<String, dynamic> toMap() {
    return {
      'transaction': transaction,
    };
  }

}

class WalletCrudStateError extends WalletCrudState {
  final String errorMessage;

  final bool isConnectionTimeout;
  final bool isSocket;

  WalletCrudStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false});


}
