import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
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
    // Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOffline = connectivityResult == ConnectivityResult.none;

    if (!isOffline) {
      try {
        // Try fetching from API
        final products = await remoteDataSource.fetchProducts();
        // Cache products locally
        await localDataSource.cacheProducts(products);
        return products;
      } catch (e) {
        print('API fetch error: $e');
        // Fall back to cached products
        final cachedProducts = await localDataSource.getCachedProducts();
        return cachedProducts; // Return empty list if cache is empty
      }
    } else {
      // Offline: return cached products
      final cachedProducts = await localDataSource.getCachedProducts();
      return cachedProducts; // Return empty list if cache is empty
    }
  }
}
