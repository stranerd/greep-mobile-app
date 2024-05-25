import 'package:greep/application/response.dart';
import 'package:greep/domain/product/product.dart';
import 'package:greep/domain/product/product_client.dart';

class ProductService {
  final ProductClient productClient;

  ProductService({required this.productClient});

  Future<ResponseEntity<List<Product>>> fetchMarketplaceProducts(
      {String? tagId}) async {
    return await productClient.fetchMarketplaceProducts(tagId: tagId);
  }

  Future<ResponseEntity<List<Product>>> fetchRecommendedProducts(
     ) async {
    return await productClient.fetchRecommendedProducts();
  }

  Future<ResponseEntity<List<Product>>> fetchProductsByIds(
      {required List<String> productIds}) async {
    return await productClient.fetchProductsByIds(productIds: productIds);
  }


  Future<ResponseEntity<List<Product>>> searchProducts(
      {required String query}) async {
    return await productClient.searchProducts(query: query);
  }
}
