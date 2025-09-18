import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/wishlist_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository repository;

  WishlistBloc(this.repository) : super(WishlistInitial()) {
    on<LoadWishlistEvent>((event, emit) async {
      emit(WishlistLoading());
      try {
        final wishlist = await repository.getWishlist();
        emit(WishlistLoaded(wishlist));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });

    on<AddToWishlistEvent>((event, emit) async {
      try {
        await repository.addToWishlist(event.product);
        final wishlist = await repository.getWishlist();
        emit(WishlistLoaded(wishlist));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });

    on<RemoveFromWishlistEvent>((event, emit) async {
      try {
        await repository.removeFromWishlist(event.productId);
        final wishlist = await repository.getWishlist();
        emit(WishlistLoaded(wishlist));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });

    on<ClearWishlistEvent>((event, emit) async {
      try {
        await repository.clearWishlist();
        emit(const WishlistLoaded([]));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });
  }
}