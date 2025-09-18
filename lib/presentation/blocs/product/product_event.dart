part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

// Triggers product fetching with optional wishlist sync
class FetchProductsEvent extends ProductEvent {
  final List<Product>? wishlist;

  const FetchProductsEvent({this.wishlist});

  @override
  List<Object> get props => [wishlist ?? []];
}

// Triggers product filtering by search query
class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object> get props => [query];
}