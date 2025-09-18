import '../entities/product.dart';

abstract class WishlistRepository {
  Future<void> addToWishlist(Product product);
  Future<void> removeFromWishlist(String productId);
  Future<List<Product>> getWishlist();
  Future<void> clearWishlist();
}
