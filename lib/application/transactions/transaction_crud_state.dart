part of 'transaction_crud_cubit.dart';

@immutable
abstract class TransactionCrudState {}

class TransactionCrudInitial extends TransactionCrudState {
}

class TransactionCrudStateLoading extends TransactionCrudState {}
class TransactionCrudStateSuccess extends TransactionCrudState {}

class TransactionCrudStateFailure extends TransactionCrudState {
  final String errorMessage;

  TransactionCrudStateFailure({required this.errorMessage});


}
