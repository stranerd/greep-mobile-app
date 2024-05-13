class Wallet {

  final String id;
  final num amount;
  final String currency;
  final bool hasPin;

  Wallet({required this.id, required this.amount, required this.currency, required this.hasPin});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id'] ?? "",
      amount: map['balance']['amount'] ?? 0,
      currency: map["balance"]['currency'] ?? "",
      hasPin: map['hasPin'] == true
    );
  }

  @override
  String toString() {
    return 'Wallet{id: $id, amount: $amount, currency: $currency}';
  }
}
