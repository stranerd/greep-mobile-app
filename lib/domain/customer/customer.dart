import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String name;
  final num debt;


  const Customer({required this.id, required this.name, required this.debt});


  factory Customer.fromServer(dynamic data){
    return Customer(id: data["id"], name: data["name"],debt: data["debt"] ?? 0);
  }

  @override
  String toString() {
    return 'Customer{id: $id, name: $name}, ';
  }

  @override
  List<Object?> get props => [id];
}
