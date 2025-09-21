import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../../data/data_sources/local_data_source.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localDataSource =
        Provider.of<LocalDataSource>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isLargeTablet = screenSize.width > 900;

    return FutureBuilder<Product?>(
      future: localDataSource.getProductById(product.id),
      builder: (context, snapshot) {
        Product displayProduct = product;
        if (snapshot.hasData && snapshot.data != null) {
          displayProduct = snapshot.data!;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Product Details",
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: isTablet ? 22 : 20,
              ),
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
                      size: isTablet ? 28 : 24,
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
          body: isLargeTablet
              ? _buildTabletLayout(context, theme, displayProduct)
              : _buildMobileLayout(context, theme, displayProduct),
        );
      },
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, ThemeData theme, Product displayProduct) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(context, theme, displayProduct, isTablet),
                SizedBox(height: isTablet ? 24 : 20),
                _buildProductInfo(context, theme, displayProduct, isTablet),
                SizedBox(height: isTablet ? 100 : 80),
              ],
            ),
          ),
        ),
        _buildBottomButton(context, theme, isTablet),
      ],
    );
  }

  Widget _buildTabletLayout(
      BuildContext context, ThemeData theme, Product displayProduct) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Image
                Expanded(
                  flex: 5,
                  child:
                      _buildProductImage(context, theme, displayProduct, true),
                ),
                const SizedBox(width: 40),
                // Right side - Info
                Expanded(
                  flex: 5,
                  child:
                      _buildProductInfo(context, theme, displayProduct, true),
                ),
              ],
            ),
          ),
        ),
        _buildBottomButton(context, theme, true),
      ],
    );
  }

  Widget _buildProductImage(BuildContext context, ThemeData theme,
      Product displayProduct, bool isTablet) {
    final imageHeight = isTablet ? 400.0 : 300.0;
    final borderRadius = isTablet ? 24.0 : 16.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Hero(
        tag: displayProduct.imageUrl,
        child: Container(
          width: double.infinity,
          height: imageHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                blurRadius: isTablet ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Image.network(
            displayProduct.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: isTablet ? 50 : 40,
                  height: isTablet ? 50 : 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: theme.colorScheme.primary,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(
                Icons.broken_image,
                size: isTablet ? 120 : 100,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, ThemeData theme,
      Product displayProduct, bool isTablet) {
    final titleFontSize = isTablet ? 28.0 : 20.0;
    final priceFontSize = isTablet ? 26.0 : 22.0;
    final categoryFontSize = isTablet ? 16.0 : 14.0;
    final ratingFontSize = isTablet ? 16.0 : 14.0;
    final descriptionFontSize = isTablet ? 16.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Price
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Text(
                displayProduct.title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${displayProduct.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: priceFontSize,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 16 : 12),

        // Category and Rating
        Wrap(
          spacing: isTablet ? 16 : 12,
          runSpacing: isTablet ? 12 : 8,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 16 : 12,
                vertical: isTablet ? 8 : 6,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
              ),
              child: Text(
                displayProduct.category,
                style: TextStyle(
                  fontSize: categoryFontSize,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 16 : 12,
                vertical: isTablet ? 8 : 6,
              ),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: isTablet ? 20 : 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    displayProduct.rating.toString(),
                    style: TextStyle(
                      fontSize: ratingFontSize,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 24 : 20),

        // Description
        Text(
          "Description",
          style: TextStyle(
            fontSize: isTablet ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Text(
          displayProduct.description,
          style: TextStyle(
            fontSize: descriptionFontSize,
            height: 1.6,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildBottomButton(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 400 : double.infinity,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 18 : 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Added to cart!",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(isTablet ? 24 : 16),
                  ),
                );
              },
              child: Text(
                "Add to Cart",
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
