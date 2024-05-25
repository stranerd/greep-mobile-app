
import 'package:greep/domain/product/product.dart';

class Cart {
  final String id;
  final DateTime createdDate;
  final String vendorId;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.items,
    required this.vendorId,
    required this.createdDate
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items,
      'vendorId': vendorId,
      'createdDate': createdDate.toString()
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    List<CartItem> items = [];
    map["products"].forEach(
      (e) => items.add(CartItem.fromMap(e)),
    );

    return Cart(
      id: map['id'] ?? "",
      vendorId: map['vendorId'] ?? "",
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      items: items,
    );
  }



  @override
  String toString() {
    return 'Cart{id: $id, items: $items}';
  }

  Cart copyWith({
    String? id,
    List<CartItem>? items,
    String? vendorId,
    DateTime? createdAt,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      vendorId: vendorId ?? this.vendorId,
      createdDate: createdAt ?? this.createdDate
    );
  }
}

class CartItem {
  final String id;
  final String currency;
  final Product? product;
  final num amount;
  final int quantity;

  CartItem(
      {required this.id,
      required this.currency,
      required this.amount,
        this.product,
      required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currency': currency,
      'amount': amount,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? "",
      currency: map['currency'] ?? "",
      amount: map['amount'] ?? 0,
      quantity: map['quantity'] ?? 0,
    );
  }




  @override
  String toString() {
    return 'CartItem{id: $id, currency: $currency, amount: $amount, quantity: $quantity}';
  }

  CartItem copyWith({
    String? id,
    String? currency,
    Product? product,
    num? amount,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
