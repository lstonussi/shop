import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: orders.items.isEmpty
          ? Container(
              child: Center(
                child: Text('Sem Pedidos'),
              ),
            )
          : ListView.builder(
              itemCount: orders.itemsCount,
              itemBuilder: (ctx, i) => OrderWidget(
                order: orders.items[i],
              ),
            ),
    );
  }
}
