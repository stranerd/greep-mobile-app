part of 'user_transactions_cubit.dart';

abstract class UserTransactionsState {}

class UserTransactionsInitial extends UserTransactionsState {}

class UserTransactionsStateLoading extends UserTransactionsState {}

class UserTransactionsStateFetched extends UserTransactionsState {
  final List<Transaction> transactions;
  final String userId;

  UserTransactionsStateFetched({required this.transactions,required this.userId});

}

class UserTransactionsStateError extends UserTransactionsState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  UserTransactionsStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false});
}
