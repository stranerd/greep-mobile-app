part of 'user_transactions_cubit.dart';

abstract class UserTransactionsState {}

class UserTransactionsInitial extends UserTransactionsState {}

class UserTransactionsStateLoading extends UserTransactionsState {}

class UserTransactionsStateFetched extends UserTransactionsState {
  final List<Transaction> transactions;

  UserTransactionsStateFetched({required this.transactions});

}

class UserTransactionsStateError extends UserTransactionsState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  UserTransactionsStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false});
}
