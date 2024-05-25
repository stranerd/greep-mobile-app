class OrderCheckoutPriceResponse {
  final num? vatPercentage;
  final num? vat;
  final num? fee;
  final num? subTotal;
  final num? total;
  final num? payable;
  final String currency;

  OrderCheckoutPriceResponse(
      {required this.vatPercentage,
      required this.vat,
      required this.fee,
      required this.subTotal,
      required this.total,
      required this.payable,
      required this.currency});

  Map<String, dynamic> toMap() {
    return {
      'vatPercentage': vatPercentage,
      'vat': vat,
      'fee': fee,
      'subTotal': subTotal,
      'total': total,
      'payable': payable,
      'currency': currency,
    };
  }

  factory OrderCheckoutPriceResponse.fromMap(Map<String, dynamic> map) {
    return OrderCheckoutPriceResponse(
      vatPercentage: map['vatPercentage'],
      vat: map['vat'],
      fee: map['fee'],
      subTotal: map['subTotal'],
      total: map['total'],
      payable: map['payable'],
      currency: map['currency'] ?? "",
    );
  }

  @override
  String toString() {
    return 'OrderCheckoutPriceResponse{vatPercentage: $vatPercentage, vat: $vat, fee: $fee, subTotal: $subTotal, total: $total, payable: $payable, currency: $currency}';
  }
}
