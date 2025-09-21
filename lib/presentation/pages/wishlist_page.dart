import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../widgets/home/product_card.dart';
import 'product_details.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  // Responsive grid calculations
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    context.read<WishlistBloc>().add(const LoadWishlistEvent());

    return Scaffold(
      appBar: AppBar(
        centerTitle: !isTablet,
        title: Text(
          "Wishlist",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              final hasItems =
                  state is WishlistLoaded && state.wishlist.isNotEmpty;

              return AnimatedOpacity(
                opacity: hasItems ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: hasItems
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurface.withOpacity(0.5),
                    size: isTablet ? 28 : 24,
                  ),
                  onPressed: hasItems
                      ? () {
                          _showClearConfirmationDialog(
                              context, theme, isTablet);
                        }
                      : null,
                ),
              );
            },
          ),
          SizedBox(width: isTablet ? 16 : 12),
        ],
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: isTablet ? 60 : 50,
                    height: isTablet ? 60 : 50,
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                      strokeWidth: 3,
                    ),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    "Loading wishlist...",
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is WishlistLoaded) {
            if (state.wishlist.isEmpty) {
              return _buildEmptyWishlist(context, theme, isTablet);
            }
            return _buildWishlistGrid(context, state.wishlist, theme, isTablet);
          } else if (state is WishlistError) {
            return _buildErrorState(context, theme, isTablet, state.message);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyWishlist(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getHorizontalPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: isTablet ? 80 : 64,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: isTablet ? 24 : 20),
            Text(
              "Your wishlist is empty!",
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 40 : 20,
              ),
              child: Text(
                "Start adding products to your wishlist by tapping the heart icon on any product.",
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: isTablet ? 32 : 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 24,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                ),
              ),
              child: Text(
                "Browse Products",
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistGrid(BuildContext context, List<Product> wishlist,
      ThemeData theme, bool isTablet) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              _getHorizontalPadding(context),
              isTablet ? 20 : 16,
              _getHorizontalPadding(context),
              isTablet ? 12 : 8,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: theme.colorScheme.error,
                  size: isTablet ? 24 : 20,
                ),
                SizedBox(width: isTablet ? 12 : 8),
                Text(
                  "${wishlist.length} ${wishlist.length == 1 ? 'item' : 'items'} in wishlist",
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(context),
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _calculateCrossAxisCount(context),
              mainAxisSpacing: _getGridSpacing(context),
              crossAxisSpacing: _getGridSpacing(context),
              childAspectRatio: _calculateChildAspectRatio(context),
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = wishlist[index];
                return Hero(
                  tag: "wishlist_${product.id}",
                  child: ProductCard(
                    imageUrl: product.imageUrl,
                    title: product.title,
                    subtitle: product.subtitle,
                    price: product.price,
                    rating: product.rating,
                    isFavorite: true,
                    isTablet: isTablet,
                    onFavoriteTap: () {
                      _showRemoveConfirmationDialog(
                        context,
                        theme,
                        isTablet,
                        product,
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsPage(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
              childCount: wishlist.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: isTablet ? 32 : 20),
        ),
      ],
    );
  }

  Widget _buildErrorState(
      BuildContext context, ThemeData theme, bool isTablet, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getHorizontalPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isTablet ? 80 : 64,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: isTablet ? 20 : 16),
            Text(
              "Oops! Something went wrong",
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              message,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 24 : 20),
            ElevatedButton(
              onPressed: () {
                context.read<WishlistBloc>().add(const LoadWishlistEvent());
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 24,
                  vertical: isTablet ? 16 : 12,
                ),
              ),
              child: Text(
                "Try Again",
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

  void _showRemoveConfirmationDialog(
    BuildContext context,
    ThemeData theme,
    bool isTablet,
    Product product,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          ),
          title: Text(
            "Remove from Wishlist",
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to remove \"${product.title}\" from your wishlist?",
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<WishlistBloc>()
                    .add(RemoveFromWishlistEvent(product.id));
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Removed from wishlist",
                      style: TextStyle(fontSize: isTablet ? 16 : 14),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: Text(
                "Remove",
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClearConfirmationDialog(
      BuildContext context, ThemeData theme, bool isTablet) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          ),
          title: Text(
            "Clear Wishlist",
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to remove all items from your wishlist? This action cannot be undone.",
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<WishlistBloc>().add(const ClearWishlistEvent());
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Wishlist cleared!",
                      style: TextStyle(fontSize: isTablet ? 16 : 14),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: Text(
                "Clear All",
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
