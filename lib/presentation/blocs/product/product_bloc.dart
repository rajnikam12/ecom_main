import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/use_cases/fetch_products.dart';

part 'product_event.dart';
part 'product_state.dart';

// Manages product fetching and search, syncing with wishlist
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProducts fetchProducts;

  ProductBloc(this.fetchProducts) : super(ProductInitial()) {
    // Fetch products from API or cache
    on<FetchProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await fetchProducts();
        if (products.isEmpty) {
          emit(
              const ProductError('Offline mode: No cached products available'));
        } else {
          emit(ProductLoaded(products, event.wishlist ?? []));
        }
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    // Filter products by search query
    on<SearchProductsEvent>((event, emit) async {
      if (state is ProductLoaded) {
        final currentState = state as ProductLoaded;
        final filtered = currentState.allProducts
            .where((p) =>
                p.title.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(ProductLoaded(filtered, currentState.wishlist));
      }
    });
  }
}
