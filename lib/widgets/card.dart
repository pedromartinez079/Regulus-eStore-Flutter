import 'package:flutter/material.dart';
import 'package:e_store/screens/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Map product;

  @override
  Widget build(BuildContext context) {
    String imagePath = product['images'][0];
    const String fallbackImagePath = 'assets/images/under-construction.jpg';

    if (!imagePath.contains('on-line') && !imagePath.contains('carrusel')) {
      imagePath = fallbackImagePath;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ProductPage(product: product,),
                )
              );
          }, //Show product screen
          child: Card(
            elevation: 4.0,
            child: SizedBox(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        //print('Image load: $error');
                        return Image.asset(
                          fallbackImagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['title'],
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'S/. ${product['pricePEN']}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}