import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/remote_data_source.dart';
import '../data_sources/local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  ProductRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<Product>> getProducts() async {
    try {
      print('🔄 Starting product fetch...');

      // Try to fetch from API first
      final products = await remoteDataSource.fetchProducts();
      print('✅ API fetch successful: ${products.length} products');

      // Cache the products for offline use
      try {
        await localDataSource.cacheProducts(products);
        print('💾 Products cached successfully');
      } catch (cacheError) {
        print('⚠️ Cache error (non-critical): $cacheError');
        // Don't fail the entire operation if caching fails
      }

      return products;
    } catch (apiError) {
      print('🌐 API fetch failed: $apiError');
      print('📱 Trying to load cached products...');

      try {
        final cachedProducts = await localDataSource.getCachedProducts();

        if (cachedProducts.isNotEmpty) {
          print('✅ Loaded ${cachedProducts.length} cached products');
          return cachedProducts;
        } else {
          print('❌ No cached products available');
          throw Exception(
              'Unable to load products. Please check your internet connection and try again.');
        }
      } catch (cacheError) {
        print('💥 Cache load failed: $cacheError');
        throw Exception(
            'Unable to load products. Please check your internet connection and try again.');
      }
    }
  }
}
