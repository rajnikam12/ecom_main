import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/product.dart';

class LocalDataSource {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'wishlist.db');
    return await openDatabase(
      path,
      version: 3, // Incremented version to fix schema issues
      onCreate: (db, version) async {
        // Create wishlist table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS wishlist (
            id TEXT PRIMARY KEY,
            title TEXT,
            subtitle TEXT,
            price REAL,
            imageUrl TEXT,
            description TEXT,
            category TEXT,
            rating REAL
          )
        ''');
        // Create products table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS products (
            id TEXT PRIMARY KEY,
            title TEXT,
            subtitle TEXT,
            price REAL,
            imageUrl TEXT,
            description TEXT,
            category TEXT,
            rating REAL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Handle all upgrades safely
        if (oldVersion < 3) {
          // Create tables if they don't exist
          await db.execute('''
            CREATE TABLE IF NOT EXISTS wishlist (
              id TEXT PRIMARY KEY,
              title TEXT,
              subtitle TEXT,
              price REAL,
              imageUrl TEXT,
              description TEXT,
              category TEXT,
              rating REAL
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS products (
              id TEXT PRIMARY KEY,
              title TEXT,
              subtitle TEXT,
              price REAL,
              imageUrl TEXT,
              description TEXT,
              category TEXT,
              rating REAL
            )
          ''');
        }
      },
    );
  }

  Future<void> addToWishlist(Product product) async {
    try {
      final db = await database;
      await db.insert(
        'wishlist',
        {
          'id': product.id,
          'title': product.title,
          'subtitle': product.subtitle,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'description': product.description,
          'category': product.category,
          'rating': product.rating,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error adding to wishlist: $e');
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      final db = await database;
      await db.delete('wishlist', where: 'id = ?', whereArgs: [productId]);
    } catch (e) {
      print('Error removing from wishlist: $e');
      rethrow;
    }
  }

  Future<List<Product>> getWishlist() async {
    try {
      final db = await database;
      final maps = await db.query('wishlist');
      return maps
          .map((map) => Product(
                id: map['id'] as String,
                title: map['title'] as String,
                subtitle: map['subtitle'] as String,
                price: map['price'] as double,
                imageUrl: map['imageUrl'] as String,
                description: map['description'] as String,
                category: map['category'] as String,
                rating: map['rating'] as double,
              ))
          .toList();
    } catch (e) {
      print('Error getting wishlist: $e');
      return [];
    }
  }

  Future<void> clearWishlist() async {
    try {
      final db = await database;
      await db.delete('wishlist');
    } catch (e) {
      print('Error clearing wishlist: $e');
      rethrow;
    }
  }

  Future<void> cacheProducts(List<Product> products) async {
    try {
      final db = await database;

      // Use transaction for better performance and atomicity
      await db.transaction((txn) async {
        // Clear existing products
        await txn.delete('products');

        // Insert new products
        for (var product in products) {
          await txn.insert(
            'products',
            {
              'id': product.id,
              'title': product.title,
              'subtitle': product.subtitle,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'description': product.description,
              'category': product.category,
              'rating': product.rating,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      print('Successfully cached ${products.length} products');
    } catch (e) {
      print('Error caching products: $e');
      // Don't rethrow - caching failure shouldn't break the app
    }
  }

  Future<List<Product>> getCachedProducts() async {
    try {
      final db = await database;
      final maps = await db.query('products');
      final products = maps
          .map((map) => Product(
                id: map['id'] as String,
                title: map['title'] as String,
                subtitle: map['subtitle'] as String,
                price: map['price'] as double,
                imageUrl: map['imageUrl'] as String,
                description: map['description'] as String,
                category: map['category'] as String,
                rating: map['rating'] as double,
              ))
          .toList();
      print('Retrieved ${products.length} cached products');
      return products;
    } catch (e) {
      print('Error getting cached products: $e');
      return [];
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      final db = await database;
      final maps = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Product(
          id: maps[0]['id'] as String,
          title: maps[0]['title'] as String,
          subtitle: maps[0]['subtitle'] as String,
          price: maps[0]['price'] as double,
          imageUrl: maps[0]['imageUrl'] as String,
          description: maps[0]['description'] as String,
          category: maps[0]['category'] as String,
          rating: maps[0]['rating'] as double,
        );
      }
      return null;
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }
}
