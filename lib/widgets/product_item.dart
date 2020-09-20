import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProdutcItem extends StatelessWidget {
  final Product product;

  const ProdutcItem(this.product);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        product.imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {},
        ),
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
      ),
    );
  }
}
