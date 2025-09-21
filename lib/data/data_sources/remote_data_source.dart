import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/product.dart';

class RemoteDataSource {
  final http.Client client;

  RemoteDataSource(this.client);

  Future<List<Product>> fetchProducts() async {
    try {
      print('🌐 Fetching products from API...');

      final response = await client.get(
        Uri.parse('https://fakestoreapi.com/products'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception(
              'Request timeout: Please check your internet connection');
        },
      );

      print('📡 API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('✅ Successfully fetched ${jsonList.length} products');

        final products = jsonList.map((json) {
          return Product(
            id: json['id'].toString(),
            title: json['title'] ?? 'Unknown Product',
            subtitle: json['category'] ?? 'Unknown Category',
            price: (json['price'] as num?)?.toDouble() ?? 0.0,
            imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
            description: json['description'] ?? 'No description available',
            category: json['category'] ?? 'Unknown',
            rating: (json['rating']?['rate'] as num?)?.toDouble() ?? 0.0,
          );
        }).toList();

        print('🎯 Converted ${products.length} products successfully');
        return products;
      } else {
        print('❌ API Error: ${response.statusCode}');
        throw Exception(
            'Failed to load products: Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 Error in fetchProducts: $e');

      if (e.toString().contains('SocketException') ||
          e.toString().contains('ClientException') ||
          e.toString().contains('HandshakeException') ||
          e.toString().contains('timeout')) {
        throw Exception(
            'Network error: Please check your internet connection and try again');
      }

      rethrow;
    }
  }
}
