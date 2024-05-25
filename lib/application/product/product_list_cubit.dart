import 'package:bloc/bloc.dart';
import 'package:greep/domain/product/product.dart';
import 'package:greep/domain/product/product_service.dart';
import 'package:meta/meta.dart';

part 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final ProductService productService;

  ProductListCubit({
    required this.productService,
  }) : super(ProductListStateInitial());

  Future<void> fetchMarketProducts({String? tagId}) async {
    emit(ProductListStateLoading());

    var result = await productService.fetchMarketplaceProducts(tagId: tagId);

    if (result.isError) {
      emit(
        ProductListStateError(
          result.errorMessage,
        ),
      );
    } else {
      emit(
        ProductListStateFetched(
          products: result.data!,
        ),
      );
    }
  }

  Future<void> fetchRecommendedProducts() async {
    emit(ProductListStateLoading());

    var result = await productService.fetchRecommendedProducts();

    if (result.isError) {
      emit(
        ProductListStateError(
          result.errorMessage,
        ),
      );
    } else {
      emit(
        ProductListStateFetched(
          products: result.data!,
        ),
      );
    }
  }


  Future<void> fetchProductsById({required List<String> productIds, bool softUpdate = false}) async {

   if (!softUpdate) {
     emit(ProductListStateLoading());
   }
    var result = await productService.fetchProductsByIds(productIds: productIds,);

    if (result.isError) {
      emit(
        ProductListStateError(
          result.errorMessage,
        ),
      );
    } else {
      emit(
        ProductListStateFetched(
          products: result.data!,
        ),
      );
    }
  }
}
