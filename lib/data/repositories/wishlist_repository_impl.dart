import '../../domain/entities/product.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../data_sources/local_data_source.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final LocalDataSource localDataSource;

  WishlistRepositoryImpl(this.localDataSource);

  @override
  Future<void> addToWishlist(Product product) async {
    await localDataSource.addToWishlist(product);
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    await localDataSource.removeFromWishlist(productId);
  }

  @override
  Future<List<Product>> getWishlist() async {
    return await localDataSource.getWishlist();
  }

  @override
  Future<void> clearWishlist() async {
    await localDataSource.clearWishlist();
  }
}