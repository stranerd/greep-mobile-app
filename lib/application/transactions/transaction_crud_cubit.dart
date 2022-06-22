import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/request/add_balance_request.dart';
import 'package:grip/application/transactions/request/add_expense_request.dart';
import 'package:grip/application/transactions/request/add_trip_request.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/transaction/transaction_service.dart';
import 'package:meta/meta.dart';

part 'transaction_crud_state.dart';

class TransactionCrudCubit extends Cubit<TransactionCrudState> {
  TransactionCrudCubit({required this.transactionService}) : super(TransactionCrudInitial());

  final TransactionService transactionService;

  void addTrip({required String customerName, required num paidAmount, required num amount, required String paymentType, required String description, required DateTime dateRecorded}) async {
    emit(TransactionCrudStateLoading());
    var response = await transactionService.addTrip(AddTripRequest(customerName: customerName, description: description, amount: amount, dateRecorded: dateRecorded, paymentType: paymentType, paidAmount: paidAmount));

    if (response.isError){
      emit(TransactionCrudStateFailure(errorMessage: response.errorMessage ?? "An error occurred"));
    }

    else {
      emit(TransactionCrudStateSuccess());
      _refreshTransactions();
    }
  }

  void addExpense({required String name, required num amount, required String description, required DateTime dateRecorded}) async {
    emit(TransactionCrudStateLoading());

    var response = await transactionService.addExpense(AddExpenseRequest(name: name, description: description, amount: amount, dateRecorded: dateRecorded,));

    if (response.isError){
      emit(TransactionCrudStateFailure(errorMessage: response.errorMessage ?? "An error occured"));
    }

    else {
      emit(TransactionCrudStateSuccess());
      _refreshTransactions();

    }
  }

  void addBalance({required String parentId, required num amount, required String paymentType, required String description, required DateTime dateRecorded}) async {
    emit(TransactionCrudStateLoading());

    var response = await transactionService.addBalance(AddBalanceRequest(parentId: paymentType, description: description, amount: amount, dateRecorded: dateRecorded,));

    if (response.isError){
      emit(TransactionCrudStateFailure(errorMessage: response.errorMessage ?? "An error occurred"));
    }

    else {
      emit(TransactionCrudStateSuccess());
      _refreshTransactions();
    }
  }

  void _refreshTransactions(){
    GetIt.I<UserTransactionsCubit>().fetchUserTransactions(requestId: GetIt.I<UserCubit>().userId!,fullRefresh: true);
  }
}
