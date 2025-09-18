import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../../data/data_sources/local_data_source.dart';

// Shows product details with theme-aware styling, Indian Rupee symbol, and offline support
class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localDataSource =
        Provider.of<LocalDataSource>(context, listen: false);

    return FutureBuilder<Product?>(
      future: localDataSource.getProductById(product.id), // Fetch from cache
      builder: (context, snapshot) {
        Product displayProduct = product; // Default to passed product
        if (snapshot.hasData && snapshot.data != null) {
          displayProduct = snapshot.data!; // Use cached product if available
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Product Details",
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            actions: [
              BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, state) {
                  bool isFavorite = false;
                  if (state is WishlistLoaded) {
                    isFavorite =
                        state.wishlist.any((p) => p.id == displayProduct.id);
                  }
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        context
                            .read<WishlistBloc>()
                            .add(RemoveFromWishlistEvent(displayProduct.id));
                      } else {
                        context
                            .read<WishlistBloc>()
                            .add(AddToWishlistEvent(displayProduct));
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Hero(
                    tag: displayProduct.imageUrl,
                    child: Image.network(
                      displayProduct.imageUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        size: 100,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        displayProduct.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      "₹${displayProduct.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        displayProduct.category,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Icon(Icons.star,
                            color: theme.colorScheme.secondary, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          displayProduct.rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  displayProduct.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Added to cart!",
                        style: TextStyle(color: theme.colorScheme.onPrimary),
                      ),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                },
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
