import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'presentation/theme/app_theme.dart';
import 'presentation/pages/home_page.dart';
import 'data/data_sources/remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/use_cases/fetch_products.dart';
import 'presentation/blocs/product/product_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';
import 'data/data_sources/local_data_source.dart';
import 'data/repositories/wishlist_repository_impl.dart';
import 'presentation/blocs/wishlist/wishlist_bloc.dart';

// App entry point with Bloc providers
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
            create: (_) =>
                RemoteDataSource(http.Client())), // Added http.Client
        Provider(create: (_) => LocalDataSource()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc()..add( LoadThemeEvent()),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              FetchProducts(
                ProductRepositoryImpl(
                  context.read<RemoteDataSource>(),
                  context.read<LocalDataSource>(),
                ),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => WishlistBloc(
              WishlistRepositoryImpl(context.read<LocalDataSource>()),
            )..add(const LoadWishlistEvent()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.themeMode,
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}
