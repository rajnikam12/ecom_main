part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWishlistEvent extends WishlistEvent {
  const LoadWishlistEvent();
}

class AddToWishlistEvent extends WishlistEvent {
  final Product product;

  const AddToWishlistEvent(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveFromWishlistEvent extends WishlistEvent {
  final String productId;

  const RemoveFromWishlistEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class ClearWishlistEvent extends WishlistEvent {
  const ClearWishlistEvent();
}
