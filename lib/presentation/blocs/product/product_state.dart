part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products; // Displayed products (filtered or all)
  final List<Product> allProducts; // All fetched products
  final List<Product> wishlist; // Wishlist for favorite state

  const ProductLoaded(this.products, this.wishlist) : allProducts = products;

  ProductLoaded copyWith({List<Product>? products, List<Product>? wishlist}) {
    return ProductLoaded(
      products ?? this.products,
      wishlist ?? this.wishlist,
    );
  }

  @override
  List<Object> get props => [products, allProducts, wishlist];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
