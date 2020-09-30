import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/orders.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({this.order});

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('R\$${widget.order.total}'),
            subtitle: Text(
              DateFormat('dd/MM/yyy HH:mm').format(widget.order.date),
            ),
            trailing: IconButton(
              icon:
                  !expanded ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded)
            Container(
              height: (widget.order.products.length * 25.0) + 10,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView(
                children: widget.order.products.map((e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${e.quantity}x R\$${e.price}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
