part of 'product_list_cubit.dart';

@immutable
abstract class ProductListState {}

class ProductListStateInitial extends ProductListState {}


class ProductListStateFetched extends ProductListState {

  final List<Product> products;

  ProductListStateFetched({required this.products});

  Map<String, dynamic> toMap() {
    return {
      'products': this.products,
    };
  }

  factory ProductListStateFetched.fromMap(Map<String, dynamic> map) {
    return ProductListStateFetched(
      products: map['products'] as List<Product>,
    );
  }

  @override
  String toString() {
    return 'ProductListStateFetched{products: $products}';
  }
}


class ProductListStateLoading extends ProductListState {}


class ProductListStateError extends ProductListState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  ProductListStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false});
}
