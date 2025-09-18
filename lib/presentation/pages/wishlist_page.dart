import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../widgets/home/product_card.dart';
import 'product_details.dart';

// Displays wishlist items with theme-aware styling
class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 4 : 2;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    context.read<WishlistBloc>().add(LoadWishlistEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wishlist",
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              context.read<WishlistBloc>().add(ClearWishlistEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Wishlist cleared!",
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return Center(
                child: CircularProgressIndicator(
                    color: theme.colorScheme.primary));
          } else if (state is WishlistLoaded) {
            if (state.wishlist.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your wishlist is empty!",
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: state.wishlist.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _calculateCrossAxisCount(context),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = state.wishlist[index];
                  return ProductCard(
                    imageUrl: product.imageUrl,
                    title: product.title,
                    subtitle: product.subtitle,
                    price: product.price,
                    rating: product.rating,
                    isFavorite: true,
                    onFavoriteTap: () {
                      context
                          .read<WishlistBloc>()
                          .add(RemoveFromWishlistEvent(product.id));
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsPage(product: product),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is WishlistError) {
            return Center(
                child: Text("Error: ${state.message}",
                    style: TextStyle(color: theme.colorScheme.onSurface)));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
