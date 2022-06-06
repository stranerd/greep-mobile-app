class TransactionSummary {
   num amount;
   num trips;
   num expenses;

  TransactionSummary({required this.amount, required this.trips, required this.expenses});


  factory TransactionSummary.Zero() {
    return TransactionSummary(amount: 0, trips: 0, expenses: 0);
  }

   @override
  String toString() {
    return 'TransactionSummary{amount: $amount, trips: $trips, expenses: $expenses}';
  }
}
