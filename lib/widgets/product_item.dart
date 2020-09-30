import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/routes_app.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    Future<bool> _showDialog() async {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Tem certeza?'),
          content: Text('Deseja remover o produto ${product.title}?'),
          actions: [
            FlatButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
            ),
          ],
        ),
      );
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  RoutesApp.PRODUCTFORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                final products = Provider.of<Products>(context, listen: false);
                _showDialog().then((value) {
                  if (value) products.removeProduct(product.id);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
