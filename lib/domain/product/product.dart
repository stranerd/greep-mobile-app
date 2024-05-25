import 'package:equatable/equatable.dart';

class ProductPrice {

  final num amount;
  final String currency;

  ProductPrice({required this.amount, required this.currency});

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': currency,
    };
  }

  factory ProductPrice.fromMap(Map<String, dynamic> map) {
    return ProductPrice(
      amount: map['amount'] ?? 0,
      currency: map['currency']??"",
    );
  }

  @override
  String toString() {
    return 'ProductPrice{amount: $amount, currency: $currency}';
  }


}

class ProductOwner {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String photoUrl;

  ProductOwner({required this.id, required this.firstName, required this.lastName, required this.username, required this.photoUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'photoUrl': photoUrl,
    };
  }

  factory ProductOwner.fromMap(Map<String, dynamic> map) {
    return ProductOwner(
      id: map['id'] ??"",
      firstName: map['bio']?['firstName'] ?? "",
      lastName: map['bio']?['last']??"",
      username: map['username']??"",
      photoUrl: map['photo']??"",
    );
  }

  @override
  String toString() {
    return 'ProductOwner{id: $id, firstName: $firstName, lastName: $lastName, username: $username, photoUrl: $photoUrl}';
  }


}

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final String banner;
  final ProductPrice price;

  final ProductOwner user;
  final DateTime date;

  const Product({required this.id, required this.title, required this.description, required this.banner, required this.price, required this.user, required this.date});


  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'banner': banner,
      'price': price,
      'user': user,
      'date': date,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ??"",
      title: map['title'] ??"",
      description: map['description'] ?? "",
      banner: map['banner']?['link'] ?? "",
      price: ProductPrice.fromMap(map['price']),
      user: ProductOwner.fromMap(map['user']),
      date:  DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, banner: $banner, price: $price, user: $user, date: $date}';
  }
}
