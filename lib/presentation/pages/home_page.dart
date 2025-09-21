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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";

  // Responsive design calculations
  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 6; // Large tablets/desktop
    if (screenWidth > 900) return 4; // Medium tablets
    if (screenWidth > 600) return 3; // Small tablets
    return 2; // Mobile phones
  }

  double _calculateChildAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 900) return 0.75; // Tablets - more square
    return 0.65; // Mobile - more rectangular
  }

  double _getHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 32.0;
    if (screenWidth > 600) return 24.0;
    return 16.0;
  }

  double _getGridSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 900) return 16.0;
    return 12.0;
  }

  @override
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(const LoadWishlistEvent());
    _loadProducts();
  }

  void _loadProducts() {
    final wishlistState = context.read<WishlistBloc>().state;
    final wishlist =
        wishlistState is WishlistLoaded ? wishlistState.wishlist : <Product>[];
    context.read<ProductBloc>().add(FetchProductsEvent(wishlist: wishlist));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: !isTablet, // Center on mobile, left-align on tablet
        title: Text(
          "Ecommerce",
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 32 : 28,
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
              size: isTablet ? 28 : 24,
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(SwitchThemeEvent());
            },
          ),
          // Refresh button
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: theme.colorScheme.onSurface,
              size: isTablet ? 28 : 24,
            ),
            onPressed: _loadProducts,
          ),
          // Wishlist button
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              size: isTablet ? 32 : 28,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistPage()),
              ).then((_) => _loadProducts());
            },
          ),
          SizedBox(width: isTablet ? 16 : 12),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadProducts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(_getHorizontalPadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar - responsive width
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 600 : double.infinity,
                  ),
                  child: const CustomTextField(),
                ),
                SizedBox(height: isTablet ? 24 : 20),

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
                SizedBox(height: isTablet ? 24 : 20),

                // Product grid
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, productState) {
                    return BlocBuilder<WishlistBloc, WishlistState>(
                      builder: (context, wishlistState) {
                        List<Product> wishlist = [];
                        if (wishlistState is WishlistLoaded) {
                          wishlist = wishlistState.wishlist;
                        }

                        if (productState is ProductLoading) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        } else if (productState is ProductLoaded) {
                          final displayedProducts = selectedCategory == "All"
                              ? productState.products
                              : productState.products
                                  .where((product) =>
                                      product.category == selectedCategory)
                                  .toList();

                          if (displayedProducts.isEmpty &&
                              selectedCategory != "All") {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: isTablet ? 80 : 64,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.5),
                                    ),
                                    SizedBox(height: isTablet ? 20 : 16),
                                    Text(
                                      "No products found in this category",
                                      style: TextStyle(
                                        fontSize: isTablet ? 20 : 18,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: displayedProducts.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _calculateCrossAxisCount(context),
                              mainAxisSpacing: _getGridSpacing(context),
                              crossAxisSpacing: _getGridSpacing(context),
                              childAspectRatio:
                                  _calculateChildAspectRatio(context),
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
                                isTablet: isTablet,
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
                                  ).then((_) => _loadProducts());
                                },
                              );
                            },
                          );
                        } else if (productState is ProductError) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: isTablet ? 80 : 64,
                                    color: theme.colorScheme.error,
                                  ),
                                  SizedBox(height: isTablet ? 20 : 16),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 40 : 20,
                                    ),
                                    child: Text(
                                      productState.message,
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : 16,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 24 : 20),
                                  ElevatedButton(
                                    onPressed: _loadProducts,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isTablet ? 32 : 24,
                                        vertical: isTablet ? 16 : 12,
                                      ),
                                    ),
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    );
                  },
                ),
                // Bottom padding for better scroll experience
                SizedBox(height: isTablet ? 32 : 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
