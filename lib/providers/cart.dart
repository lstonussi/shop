import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.productId,
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get valorAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id))
      _items.update(
        product.id,
        (existingItem) => CartItem(
          productId: product.id,
          id: existingItem.id,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
          title: existingItem.title,
        ),
      );
    else
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          productId: product.id,
          id: Random().nextDouble().toString(),
          title: product.title,
          quantity: 1,
          price: product.price,
        ),
      );
    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CartItem(
          productId: existingItem.id,
          id: existingItem.id,
          price: existingItem.price,
          quantity: existingItem.quantity - 1,
          title: existingItem.title,
        ),
      );
    }

    notifyListeners();
  }

  void clean() {
    _items = {};
    notifyListeners();
  }
}
