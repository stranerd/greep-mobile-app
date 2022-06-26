class TransactionData {
  final TransactionType transactionType;
  final String? name;
  final PaymentType? paymentType;
  final String? customerName;
  final num? paidAmount;
  final String? customerId;

  TransactionData(
      {required this.transactionType,
      this.name,
      this.paymentType,
      this.customerName,
      this.paidAmount,
      this.customerId});

  factory TransactionData.fromServer(dynamic json) {
    return TransactionData(
      transactionType: getTransactionType(json["type"]),
      name: json["name"],
      customerName: json["customerName"],
      paidAmount: json["totalAmount"],
      customerId: json["customerId"],
      paymentType: json["paymentType"] == null
          ? null
          : getPaymentType(json["paymentType"]),
    );
  }

  static PaymentType getPaymentType(String type) {
    switch (type.toLowerCase()) {
      case "card":
        {
          return PaymentType.card;
        }
      case "cash":
        {
          return PaymentType.cash;
        }
      default:
        return PaymentType.cash;
    }
  }

  static TransactionType getTransactionType(String type) {
    switch (type.toLowerCase()) {
      case "expense":
        {
          return TransactionType.expense;
        }
      case "trip":
        {
          return TransactionType.trip;
        }
      case "balance":
        {
          return TransactionType.balance;
        }
      default:
        return TransactionType.trip;
    }
  }


  @override
  String toString() {
    return 'TransactionData{transactionType: $transactionType, name: $name, paymentType: $paymentType, customerName: $customerName, paidAmount: $paidAmount, parentId: $customerId}';
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "type": transactionType.name
    };
    
    if (transactionType == TransactionType.trip){
      map.addAll({
        "customerName": customerName,
        "totalAmount": paidAmount,
        "paymentType": paymentType!.name,
      });
    }

    else if (transactionType == TransactionType.balance){
      map.addAll({
        "parentId": customerId,
      });
    }

    else if (transactionType == TransactionType.expense){
      map.addAll({
        "name": name
      });
    }

    return map;
  }
}

enum TransactionType { expense, trip, balance }

enum PaymentType { cash, card }
