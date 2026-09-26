import 'package:flutter_riverpod/legacy.dart';

class Cart {
  final List list; // Map > {'code': '', 'pricePEN': 0, 'priceUSD': 0, 'quantity': 0}

  const Cart({
    required this.list,
  });
}

class CartNotifier extends StateNotifier<Cart> {
  CartNotifier()
    : super(const Cart(list: [],));

  void setCart(Cart list) {
    state = list;
  }

  List getCart() { return state.list; }
}

final cartProvider =
  StateNotifierProvider<CartNotifier, Cart>((ref) {
    return CartNotifier();
  });