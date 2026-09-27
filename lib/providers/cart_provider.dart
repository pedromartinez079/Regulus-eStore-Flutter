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

  Map getItem(String code) {
    var item = {};
    for (Map i in state.list) {
      if (i['code'] == code) { item = i; }
    }
    return item;
  }

  void addItem(Map item) {
    List list = List.from(state.list);

    list.add(item);
    state = Cart(list: list);
  }

  void deleteItem(String code) {
    List list = List.from(state.list);

    for (Map i in list) {
      if (i['code'] == code) { list.remove(i); }
    }
    state = Cart(list: list);
  }

  void setItemQuantity(String code, num quantity) {
    List list = List.from(state.list);

    for (Map i in list) {
      if (i['code'] == code) { i['quantity'] = quantity; }
    }
    state = Cart(list: list);
  }
}

final cartProvider =
  StateNotifierProvider<CartNotifier, Cart>((ref) {
    return CartNotifier();
  });