class TransactionData {
  final TransactionType transactionType;
  final String? name;
  final PaymentType? paymentType;
  final String? customerName;
  final num? debt;
  final num? paidAmount;
  final String? parentId;

  TransactionData(
      {required this.transactionType,
      this.name,
      this.paymentType,
      this.customerName,
      this.debt,
      this.paidAmount,
      this.parentId});

  factory TransactionData.fromServer(dynamic json) {
    print(json);
    return TransactionData(
      transactionType: getTransactionType(json["type"]),
      name: json["name"],
      customerName: json["customerName"],
      paidAmount: json["paidAmount"],
      parentId: json["parentId"],
      paymentType: json["paymentType"] == null
          ? null
          : getPaymentType(json["paymentType"]),
      debt: json["debt"],
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
  
  
  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "type": transactionType.name
    };
    
    if (transactionType == TransactionType.trip){
      map.addAll({
        "customerName": customerName,
        "paidAmount": paidAmount,
        "paymentType": paymentType!.name,
        "debt": debt
      });
    }

    else if (transactionType == TransactionType.balance){
      map.addAll({
        "parentId": parentId,
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
