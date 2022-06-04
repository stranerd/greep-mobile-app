part of 'transaction_summary_cubit.dart';

@immutable
abstract class TransactionSummaryState {}

class TransactionSummaryInitial extends TransactionSummaryState {}

class TransactionSummaryStateFetched  extends TransactionSummaryState {}
