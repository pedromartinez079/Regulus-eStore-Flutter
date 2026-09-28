import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_store/providers/cart_provider.dart';

class ShoppingCartScreen extends ConsumerStatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  ConsumerState<ShoppingCartScreen> createState() {
    return _ShoppingCartScreenState();
  }
}

class _ShoppingCartScreenState extends ConsumerState<ShoppingCartScreen> {
  bool _isCartPrefFetched = false;
  double _totalPEN = 0;
  double _totalUSD = 0;

  void _updateCartPref() async {
    final pref = await SharedPreferences.getInstance();

    await pref.setString('cart', jsonEncode(ref.read(cartProvider.notifier).getCart()));
  }

  void _getCartPref() async {
    final pref = await SharedPreferences.getInstance();
    final cartPref = pref.getString('cart');

    if (cartPref != null) {
      List list = jsonDecode(cartPref);
      ref.read(cartProvider.notifier).setCart(Cart(list: list));
    }
    
    setState(() {
      _isCartPrefFetched = true;
    });
  }

  void _updateTotals() {
    setState(() {
      _totalPEN = ref.read(cartProvider.notifier).getTotalPEN();
      _totalUSD = ref.read(cartProvider.notifier).getTotalUSD();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    if (!cartNotifier.getCart().isNotEmpty) {
      if (!_isCartPrefFetched) {_getCartPref();}
    }

    _updateTotals();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total PEN: $_totalPEN'),
                SizedBox(width: 20,),
                Text('Total USD: $_totalUSD'),
                IconButton(
                  icon: Icon(Icons.paypal),
                  onPressed: () {/* paypal procedure */},
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: cartState.list.length,
                  itemBuilder: (context, index) {
                    final item = cartState.list[index];
                    return ListTile(
                      title: Text('Item: ${item['code']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price PEN: ${item['pricePEN']}'),
                          Text('Price USD: ${item['priceUSD']}'),
                          Row(
                            children: [
                              Text('Quantity: ${item['quantity']}'),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (item['quantity'] > 1) {
                                    cartNotifier.setItemQuantity(item['code'], item['quantity'] - 1);
                                  } else {
                                    cartNotifier.deleteItem(item['code']);
                                  }
                                  _updateCartPref();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  cartNotifier.setItemQuantity(item['code'], item['quantity'] + 1);
                                  _updateCartPref();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          cartNotifier.deleteItem(item['code']);
                          _updateCartPref();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}