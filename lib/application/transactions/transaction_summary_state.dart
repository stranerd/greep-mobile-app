part of 'transaction_summary_cubit.dart';

@immutable
abstract class TransactionSummaryState {}

class TransactionSummaryInitial extends TransactionSummaryState {}
class TransactionSummaryStateLoading  extends TransactionSummaryState {}

class TransactionSummaryStateDone  extends TransactionSummaryState {}
