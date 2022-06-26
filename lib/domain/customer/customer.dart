import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String name;

  const Customer({required this.id, required this.name});


  factory Customer.fromServer(dynamic data){
    return Customer(id: data["id"], name: data["name"]);
  }

  @override
  String toString() {
    return 'Customer{id: $id, name: $name}';
  }

  @override
  List<Object?> get props => [id];
}
