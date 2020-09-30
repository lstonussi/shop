
import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final Widget child;
  final String valor;
  final Color color;
  const Badge({
    @required this.child,
    @required this.valor,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return  showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Tem certeza?'),
                    content: Text(
                        'Deseja remover o item {product.title} do carrinho?'),
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
  }}