import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    final Product produto =
        ModalRoute.of(context).settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                produto.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'R\$ ${produto.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                produto.description,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
