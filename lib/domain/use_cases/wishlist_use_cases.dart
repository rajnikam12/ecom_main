import '../entities/product.dart';
import '../repositories/wishlist_repository.dart';

// Adds a product to the wishlist
class AddToWishlist {
  final WishlistRepository repository;

  AddToWishlist(this.repository);

  Future<void> call(Product product) async {
    await repository.addToWishlist(product);
  }
}

// Removes a product from the wishlist
class RemoveFromWishlist {
  final WishlistRepository repository;

  RemoveFromWishlist(this.repository);

  Future<void> call(String productId) async {
    await repository.removeFromWishlist(productId);
  }
}

// Retrieves all wishlist products
class GetWishlist {
  final WishlistRepository repository;

  GetWishlist(this.repository);

  Future<List<Product>> call() async {
    return await repository.getWishlist();
  }
}

// Clears the entire wishlist
class ClearWishlist {
  final WishlistRepository repository;

  ClearWishlist(this.repository);

  Future<void> call() async {
    await repository.clearWishlist();
  }
}