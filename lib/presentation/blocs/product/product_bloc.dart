import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/use_cases/fetch_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProducts fetchProducts;

  ProductBloc(this.fetchProducts) : super(ProductInitial()) {
    on<FetchProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await fetchProducts();
        emit(ProductLoaded(products, event.wishlist ?? []));
      } catch (e) {
        emit(ProductError(
            'Unable to load products. Please check your internet connection and try again.'));
      }
    });

    on<SearchProductsEvent>((event, emit) async {
      if (state is ProductLoaded) {
        final currentState = state as ProductLoaded;
        if (event.query.isEmpty) {
          emit(ProductLoaded(currentState.allProducts, currentState.wishlist));
        } else {
          final filtered = currentState.allProducts
              .where((p) =>
                  p.title.toLowerCase().contains(event.query.toLowerCase()) ||
                  p.category.toLowerCase().contains(event.query.toLowerCase()))
              .toList();
          emit(ProductLoaded(filtered, currentState.wishlist));
        }
      }
    });
  }
}
