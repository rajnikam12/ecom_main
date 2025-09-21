Flutter eCommerce App A Flutter-based eCommerce application built with Clean
Architecture and BLoC state management, featuring product browsing, wishlist
management, offline support, theme toggling, and search functionality. The app
fetches products from the Fake Store API and caches data locally using sqflite
for offline access. Features

Product Browsing: View products in a responsive grid with images, titles,
categories, ratings, and prices in Indian Rupees (₹). Wishlist Management:
Add/remove products to/from a wishlist, with real-time favorite (heart) icon
updates across HomePage, ProductDetailsPage, and WishlistPage. Offline Support:
Cache products and wishlist locally using sqflite, enabling full functionality
(browsing, search, categories, wishlist) without internet. Search: Filter
products by title in real-time, works online and offline. Category Filtering:
Filter products by categories (e.g., electronics, jewelery) on HomePage, works
offline. Pull-to-Refresh: Refresh product list with API fetch (falls back to
cache offline). Theme Toggling: Switch between light and dark themes with
consistent UI (₹ symbol, colors). Reload After Navigation: Automatically reload
products when returning from ProductDetailsPage or WishlistPage to sync favorite
states. Responsive Design: Adapts to mobile (2-column grid) and tablet (4-column
grid) layouts. Error Handling: Graceful handling of offline scenarios, empty
cache, and database errors (e.g., "no such table: products").

Tech Stack

Flutter: UI framework (version: 3.x, SDK: >=2.18.0 <3.0.0). BLoC: State
management for products, wishlist, and theme. Clean Architecture: Separates
concerns into presentation, domain, and data layers. sqflite: Local database for
caching products and wishlist. http: For API requests to Fake Store API.
connectivity_plus: Detects online/offline status. provider: Dependency injection
for data sources. equatable: Simplifies state comparison in BLoC. google_fonts:
Consistent typography. shared_preferences: Persists theme settings.

Project Structure ecommerce_app/ ├── lib/ │ ├── data/ │ │ ├── data_sources/ │ │
│ ├── local_data_source.dart │ │ │ ├── remote_data_source.dart │ │ ├──
repositories/ │ │ │ ├── product_repository_impl.dart │ │ │ ├──
wishlist_repository_impl.dart │ ├── domain/ │ │ ├── entities/ │ │ │ ├──
product.dart │ │ ├── repositories/ │ │ │ ├── product_repository.dart │ │ │ ├──
wishlist_repository.dart │ │ ├── use_cases/ │ │ │ ├── fetch_products.dart │ │ │
├── wishlist_use_cases.dart │ ├── presentation/ │ │ ├── blocs/ │ │ │ ├──
product/ │ │ │ │ ├── product_bloc.dart │ │ │ │ ├── product_event.dart │ │ │ │
├── product_state.dart │ │ │ ├── theme/ │ │ │ │ ├── theme_bloc.dart │ │ │ │ ├──
theme_event.dart │ │ │ │ ├── theme_state.dart │ │ │ ├── wishlist/ │ │ │ │ ├──
wishlist_bloc.dart │ │ │ │ ├── wishlist_event.dart │ │ │ │ ├──
wishlist_state.dart │ │ ├── pages/ │ │ │ ├── home_page.dart │ │ │ ├──
product_details.dart │ │ │ ├── wishlist_page.dart │ │ ├── theme/ │ │ │ ├──
app_theme.dart │ │ ├── widgets/ │ │ │ ├── home/ │ │ │ │ ├── custom_category.dart
│ │ │ │ ├── custom_textfield.dart │ │ │ │ ├── product_card.dart │ ├── main.dart
├── pubspec.yaml ├── README.md

Setup Instructions Prerequisites

Flutter SDK: >=2.18.0 <3.0.0 Dart SDK: Included with Flutter Android Studio /
Xcode for emulators Git: For cloning the repository ADB (optional): For database
inspection on Android

Installation

Clone the Repository: git clone <repository-url> cd ecommerce_app

Install Dependencies: flutter pub get

Run the App: flutter run

Ensure a device/emulator is connected. Tested on Pixel 6 (mobile) and Pixel C
(tablet).

Build APK: flutter build apk --debug

Output: build/app/outputs/flutter-apk/app-debug.apk

Database Setup

The app uses sqflite to store data in wishlist.db with two tables: wishlist:
Stores favorite products. products: Caches API-fetched products for offline use.

Location: Android: /data/user/0/com.example.ecommerce_app/databases/wishlist.db
iOS (Simulator):
/Users/<user>/Library/Developer/CoreSimulator/Devices/<device-id>/data/Containers/Data/Application/<app-id>/Documents/wishlist.db

Schema Migration: Database version: 2 (includes products table via onUpgrade).
To reset: Uninstall the app to delete wishlist.db and recreate on next run.

Usage

Home Page:

Displays a grid of products with ₹ prices, images, categories, and ratings.
Search by title using the text field. Filter by category (e.g., "electronics",
"jewelery") using the category scroll. Toggle theme (light/dark) via the
sun/moon icon in the AppBar. Access wishlist via the heart icon in the AppBar.
Pull-to-refresh to reload products (uses cache offline). Tap a product to view
details; heart icon updates on return.

Product Details Page:

Shows product image, title, ₹ price, category, rating, and description.
Add/remove from wishlist via the heart icon (works offline). "Add to Cart"
button shows a confirmation snackbar.

Wishlist Page:

Lists favorite products with ₹ prices. Remove individual items or clear all
(works offline). Heart icons sync across pages on navigation.

Offline Mode:

Cache products online first (via HomePage). Disconnect internet (airplane mode)
and restart app: HomePage: Shows cached products or "Offline mode: No cached
products available". ProductDetailsPage: Loads cached details. WishlistPage:
Shows wishlist items. Search and category filtering work on cached products.

Testing Functional Testing

Online:

Open HomePage, verify products load with ₹ prices. Search (e.g., "jacket"),
select categories (e.g., "electronics"). Add/remove products to wishlist in
HomePage or ProductDetailsPage. Navigate to WishlistPage, verify items and clear
functionality. Toggle theme; confirm ₹ symbol and UI consistency.

Offline:

Cache products online. Enable airplane mode, restart app. Verify HomePage loads
cached products, search/categories work. Navigate to ProductDetailsPage, confirm
cached details. Add/remove from wishlist, verify heart icon sync on return to
HomePage. Pull-to-refresh; confirm cached products load.

Database Inspection

Android:adb pull /data/user/0/com.example.ecommerce_app/databases/wishlist.db

Open with SQLite browser. Query:SELECT * FROM products; SELECT * FROM wishlist;

iOS (Simulator): Locate:
/Users/<user>/Library/Developer/CoreSimulator/Devices/<device-id>/data/Containers/Data/Application/<app-id>/Documents/wishlist.db
Open with SQLite browser.

Debug Logs

Add to LocalDataSource for debugging:Future<void> cacheProducts(List<Product>
products) async { try { final db = await database; print('Caching
${products.length} products'); await db.delete('products'); for (var product in
products) { await db.insert(/* ... */); } print('Cached products: ${await
getCachedProducts()}'); } catch (e) { print('Error caching products: $e');
rethrow; } }

Check logs: flutter run or IDE console.

Error Fixes

DatabaseException: no such table: products: Fixed by incrementing database
version to 2 and adding onUpgrade to create products table.

WishlistBloc Constructor: Fixed by passing WishlistRepositoryImpl as a single
positional argument. ProductRepositoryImpl Constructor: Fixed by passing both
RemoteDataSource and LocalDataSource. RemoteDataSource Constructor: Fixed by
passing http.Client.

Known Limitations

Image Loading: Product images (Image.network) don’t load offline as they’re not
cached locally. Consider adding image caching (e.g., cached_network_image) for
full offline support. USD-to-INR Conversion: Prices are displayed in ₹ but
fetched in USD. Add conversion logic if needed (e.g., fixed rate or API).
First-Time Offline: If opened offline without prior caching, HomePage shows
"Offline mode: No cached products available".

Future Improvements

Cache product images for offline viewing. Add USD-to-INR conversion for prices.
Enhance offline UI with custom messages or retry buttons. Implement pagination
for large product lists. Add unit tests for BLoC and repository layers.

Contributing

Fork the repository. Create a feature branch: git checkout -b feature-name.
Commit changes: git commit -m "Add feature". Push to branch: git push origin
feature-name. Open a pull request.

License MIT License. See LICENSE file for details.
