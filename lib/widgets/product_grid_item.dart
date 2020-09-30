import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/utils/routes_app.dart';

class ProdutcGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              RoutesApp.PRODUCT_DETAIL,
              arguments: product,
            );
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavorite();
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Produto adicionado sucesso!'),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
              cart.addItem(product);
            },
          ),
        ),
      ),
    );
  }
}
