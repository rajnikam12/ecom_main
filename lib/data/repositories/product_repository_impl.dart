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
    try {
      // Always try to fetch from API first
      final products = await remoteDataSource.fetchProducts();

      // Cache products locally for offline use
      await localDataSource.cacheProducts(products);

      return products;
    } catch (e) {
      print('API fetch failed, trying cached products: $e');

      // If API fails, try to get cached products
      final cachedProducts = await localDataSource.getCachedProducts();

      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }

      // If no cached products, throw error
      throw Exception(
          'Unable to load products. Please check your internet connection.');
    }
  }
}
