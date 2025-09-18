import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../widgets/home/custom_category.dart';
import '../widgets/home/custom_textfield.dart';
import '../widgets/home/product_card.dart';
import 'product_details.dart';
import 'wishlist_page.dart';

// Displays product grid with search, categories, pull-to-refresh, and offline support
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";

  // Determines grid columns for responsiveness
  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 4 : 2;
  }

  @override
  void initState() {
    super.initState();
    // Fetch products and load wishlist for sync
    context.read<ProductBloc>().add(FetchProductsEvent(
        wishlist: context.read<WishlistBloc>().state is WishlistLoaded
            ? (context.read<WishlistBloc>().state as WishlistLoaded).wishlist
            : []));
    context.read<WishlistBloc>().add(LoadWishlistEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Ecommerce",
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 1.2,
            color: theme.colorScheme.primary,
          ),
        ),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(SwitchThemeEvent());
            },
          ),
          // Wishlist navigation
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              size: 28,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistPage()),
              ).then((_) {
                // Reload products on return to sync favorite states
                context.read<ProductBloc>().add(FetchProductsEvent(
                    wishlist: context.read<WishlistBloc>().state
                            is WishlistLoaded
                        ? (context.read<WishlistBloc>().state as WishlistLoaded)
                            .wishlist
                        : []));
              });
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Reload products and wishlist on pull-to-refresh
          context.read<ProductBloc>().add(FetchProductsEvent(
              wishlist: context.read<WishlistBloc>().state is WishlistLoaded
                  ? (context.read<WishlistBloc>().state as WishlistLoaded)
                      .wishlist
                  : []));
          context.read<WishlistBloc>().add(LoadWishlistEvent());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              // const CustomTextField(),
              const SizedBox(height: 20),
              // Category scroll
              CategoryScroll(
                categories: [
                  "All",
                  "electronics",
                  "jewelery",
                  "men's clothing",
                  "women's clothing",
                ],
                onCategorySelected: (selected) {
                  setState(() {
                    selectedCategory = selected;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Product grid
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, productState) {
                    return BlocBuilder<WishlistBloc, WishlistState>(
                      builder: (context, wishlistState) {
                        List<Product> wishlist = [];
                        if (wishlistState is WishlistLoaded) {
                          wishlist = wishlistState.wishlist;
                        }
                        if (productState is ProductLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (productState is ProductLoaded) {
                          final displayedProducts = selectedCategory == "All"
                              ? productState.products
                              : productState.products
                                  .where((product) =>
                                      product.category == selectedCategory)
                                  .toList();
                          return GridView.builder(
                            itemCount: displayedProducts.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _calculateCrossAxisCount(context),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                            itemBuilder: (context, index) {
                              final product = displayedProducts[index];
                              final isFavorite =
                                  wishlist.any((w) => w.id == product.id);
                              return ProductCard(
                                imageUrl: product.imageUrl,
                                title: product.title,
                                subtitle: product.subtitle,
                                price: product.price,
                                rating: product.rating,
                                isFavorite: isFavorite,
                                onFavoriteTap: () {
                                  if (isFavorite) {
                                    context.read<WishlistBloc>().add(
                                        RemoveFromWishlistEvent(product.id));
                                  } else {
                                    context
                                        .read<WishlistBloc>()
                                        .add(AddToWishlistEvent(product));
                                  }
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailsPage(product: product),
                                    ),
                                  ).then((_) {
                                    // Reload products on return to sync favorite states
                                    context.read<ProductBloc>().add(
                                        FetchProductsEvent(
                                            wishlist: context
                                                    .read<WishlistBloc>()
                                                    .state is WishlistLoaded
                                                ? (context
                                                        .read<WishlistBloc>()
                                                        .state as WishlistLoaded)
                                                    .wishlist
                                                : []));
                                  });
                                },
                              );
                            },
                          );
                        } else if (productState is ProductError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_off,
                                  size: 64,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  productState.message,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
