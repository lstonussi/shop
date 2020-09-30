import 'package:flutter/material.dart';
import 'package:shop/utils/routes_app.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Bem Vindo Usuário'),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  child: IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {},
                  ),
                ),
              )
            ],
            automaticallyImplyLeading: false, //retira o sanduiche do appbar
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(RoutesApp.HOME);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(RoutesApp.ORDERS);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Gerenciar Produto'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(RoutesApp.PRODUCTS);
            },
          ),
        ],
      ),
    );
  }
}
