import 'package:flutter/material.dart';

class CartItemInformation extends StatelessWidget {
  const CartItemInformation({super.key, required this.product});

  final Map product;

  @override
  Widget build(BuildContext context) {
    const String fallbackImagePath = 'assets/images/under-construction.jpg';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.network(
              product['images'][0],
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  fallbackImagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
          Text('Product Name: ${product['title']}', style: TextStyle(fontWeight: FontWeight.bold)),
          //Text('Price PEN: ${product['pricePEN']}'),
          //Text('Price USD: ${product['priceUSD']}'),
        ],
      ),
    );
  }
}
