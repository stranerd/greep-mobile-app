import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/AuthenticationState.dart';
import 'package:grip/application/response.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/domain/transaction/transaction_service.dart';

part 'user_transactions_state.dart';

class UserTransactionsCubit extends Cubit<UserTransactionsState> {
  UserTransactionsCubit({required this.transactionService, required this.authenticationCubit}) : super(UserTransactionsInitial()){
    _streamSubscription = authenticationCubit.stream.listen((event) {
      if (event is AuthenticationStateAuthenticated){
        fetchUserTransactions(requestId: event.userId);
      }
      if (event is AuthenticationStateNotAuthenticated){
        destroy();
      }
    });
  }

  final TransactionService transactionService;
  var hasLoaded = false;
  Map<String, Set<Transaction>> transactions = {};
  late StreamSubscription _streamSubscription;
  final AuthenticationCubit authenticationCubit;

  Future<UserTransactionsState> fetchUserTransactions(
      {required String requestId,
        bool fullRefresh = false,
        bool loadMore = false,
        bool softUpdate = false}) async {
    // when there is no load more request or a full refresh, reset pagination to default pagination
    // and emit a loading state
    if ((!softUpdate || !loadMore) || fullRefresh) {
      emit(UserTransactionsStateLoading());
    }

    // If there is more full refresh, then we can either load a cached data
    // or load paginated data from the server
    if (!fullRefresh && !softUpdate) {
      // if there is an already loaded data plus when not a load more request, load cached data
      if (hasLoaded && transactions[requestId] != null && !loadMore) {
        emit(UserTransactionsStateFetched(transactions: transactions[requestId]!.toList()));

        return UserTransactionsStateFetched(transactions: transactions[requestId]!.toList());
      } else {
        // if there is no more data, just emit previous loaded data
        // else fetch new paginated data from server
        var response = await transactionService.getUserTransactions(
          requestId,
        );
        return _checkResponse(response, requestId, loadMore);
      }
    } else {
      var response = await transactionService.getUserTransactions(
        requestId,
      );

      return _checkResponse(response, requestId, loadMore);
    }
  }

  UserTransactionsState _checkResponse(
      ResponseEntity<List<Transaction>> response, String requestId, bool loadMore) {
    if (response.isError) {
      var stateError = UserTransactionsStateError(
        response.errorMessage,
        isConnectionTimeout: response.isConnectionTimeout,
        isSocket: response.isSocket,
      );
      emit(
        stateError,
      );
      return stateError;
    } else {
      var newServices = response.data!;

      if (!loadMore) {
        hasLoaded = true;
        transactions[requestId] = Set.of(newServices);
        var stateFetched = UserTransactionsStateFetched(transactions: newServices.toList());
        emit(stateFetched);
        return stateFetched;
      } else {
        hasLoaded = true;
        transactions[requestId]!.addAll(newServices);
        emit(UserTransactionsStateFetched(transactions: transactions[requestId]!.toList()));
        return UserTransactionsStateFetched(transactions: transactions[requestId]!.toList());
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  void destroy() {
    hasLoaded = false;
    transactions.clear();
    emit(UserTransactionsInitial());
  }

  List<Transaction> getLastUserTransactions(String userId) {
    if (transactions[userId] == null || transactions[userId]!.isEmpty){
      return const [];
    }
    List<Transaction> userTransactions = transactions[userId]!.toList();
    userTransactions.sort((a, b) => a.timeAdded.compareTo(b.timeAdded));
    return userTransactions.take(5).toList();
  }
}
