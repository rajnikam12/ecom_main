import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/product.dart';

class RemoteDataSource {
  final http.Client client;

  RemoteDataSource(this.client);

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await client
          .get(
            Uri.parse('https://fakestoreapi.com/products'),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => Product(
                  id: json['id'].toString(),
                  title: json['title'],
                  subtitle: json['category'],
                  price: (json['price'] as num).toDouble(),
                  imageUrl: json['image'],
                  description: json['description'],
                  category: json['category'],
                  rating: (json['rating']['rate'] as num).toDouble(),
                ))
            .toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
