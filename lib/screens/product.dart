import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.product});

  final Map product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(flex: 2, child: _buildImages(context),),
            Expanded(flex: 3, child: _buildProductInformation(context),),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInformation(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(              
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  product['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Código: ${product['code']}'),
                Divider(),
                Text(product['description'].replaceAll('###', '')),
                Divider(),
                _buildPriceStockSection(context),
                _buildPaymentSection(context),
                //_buildImages(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceStockSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Precio'),
            Text('S/. ${product['pricePEN']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text('\$${product['priceUSD']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Stock'),
            Text('${product['stock']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            TextButton(
              onPressed: () async {
                final Uri url = Uri.parse(product['url']);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
              },
              child: Text('Más detalles', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.question_answer, color: const Color.fromARGB(255, 0, 136, 204)),
            TextButton(
              onPressed: () async {
                final Uri url = Uri.parse('https://web.telegram.org');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
              },              
              child: Text('Consultas', style: TextStyle(color: Color.fromARGB(255, 0, 136, 204), fontSize: 18)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,          
          children: [
            Icon(Icons.paypal, color: const Color.fromARGB(255, 0, 69, 124)),
            TextButton(
              onPressed: () async {
                final Uri url = Uri.parse('https://www.paypal.com');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
              },
              child: Text('Paypal', style: TextStyle(color: Color.fromARGB(255, 0, 121, 193), fontSize: 16))
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, color: Colors.blueGrey,),
            TextButton(
              onPressed: () async {
                final Uri url = Uri.parse('https://www.izipay.pe/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
              },
              child: Text('Tarjeta de crédito', style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.currency_bitcoin, color: Colors.orange),
            Expanded(
              child: Text(
                'Bitcoin y otras criptomonedas, consultar',
                style: TextStyle(fontSize: 16, color: Colors.orange),
                textAlign: TextAlign.center,
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImages(BuildContext context) {
    return ListView(
      children: product['images'].map<Widget>((imageUrl) {
        String imagePath = imageUrl;
        const fallbackImagePath = 'assets/images/under-construction.jpg';
        if (!imageUrl.contains('on-line') &&
            !imageUrl.contains('carrusel')) {
          imagePath = fallbackImagePath;
        }
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(fallbackImagePath),
        );
      }).toList(),
    );
  }
}
