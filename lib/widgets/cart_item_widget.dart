import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({this.cartItem});

  @override
  Widget build(BuildContext context) {
    final valorTotal = cartItem.price * cartItem.quantity;
    return Dismissible(
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false)
            .removeProduct(cartItem.productId);
      },
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Tem certeza?'),
            content:
                Text('Deseja remover o item ${cartItem.title} do carrinho?'),
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
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 35,
        ),
        margin: EdgeInsets.symmetric(
            vertical: 4, horizontal: 15), //para ocupar o mesmo tamanho do card
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
      ),
      key: ValueKey(cartItem.id),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            title: Text(cartItem.title),
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('${cartItem.price}'),
                ),
              ),
            ),
            subtitle: Text('Total: R\$${valorTotal.toStringAsFixed(2)}'),
            trailing: Text('${cartItem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
