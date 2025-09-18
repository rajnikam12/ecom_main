// Core business entity for a product
class Product {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String category;
  final double price;
  final double rating;
  final String description;
  final bool isFavorite;

  Product({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.rating,
    required this.description,
    this.isFavorite = false,
  });
}
