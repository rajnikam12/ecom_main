import '../../domain/entities/product.dart';

// Data model for API responses, convertible to domain entity
class ProductModel {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String category;
  final double price;
  final double rating;
  final String description;

  ProductModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.rating,
    required this.description,
  });

  // Parses JSON from Fake Store API
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      imageUrl: json['image'],
      title: json['title'],
      subtitle: json['category'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating']['rate'] as num).toDouble(),
      description: json['description'],
    );
  }

  // Converts to domain entity
  Product toEntity() {
    return Product(
      id: id,
      imageUrl: imageUrl,
      title: title,
      subtitle: subtitle,
      category: category,
      price: price,
      rating: rating,
      description: description,
    );
  }
}