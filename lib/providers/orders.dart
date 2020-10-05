import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/cart.dart';
import 'package:shop/utils/constants.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  String _baseUrl = '${Constants.BASE_API_URL}/orders';
  List<Order> _items = [];
  String _token;
  String _userId;

  Orders([this._token, this._items = const [], this._userId]);

  List<Order> get items {
    return [..._items];
  }

  //Usa esse metodo para não ficar clonando a lista toda hora
  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get('$_baseUrl/$_userId.json?auth=$_token');
    Map<String, dynamic> dados = json.decode(response.body);

    if (dados != null) {
      dados.forEach((id, order) {
        loadedItems.add(
          Order(
            id: id,
            date: DateTime.parse(order['date']),
            total: order['total'],
            products: (order['products'] as List<dynamic>).map(
              (item) {
                return CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                  productId: item['productId'],
                );
              },
            ).toList(),
          ),
        );
      });
    }
    _items = loadedItems.reversed.toList(); //muda a ordem
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      '$_baseUrl/$_userId.json?auth=$_token',
      body: json.encode({
        'total': cart.valorAmount,
        'products': cart.items.values
            .map((e) => {
                  'id': e.id,
                  'productId': e.productId,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price,
                })
            .toList(),
        'date': date.toIso8601String(),
      }),
    );
    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.valorAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }
}
