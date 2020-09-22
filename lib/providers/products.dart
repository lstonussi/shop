import 'package:flutter/cupertino.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  //Como o spread adicionar uma lista em outra lista gerando outra lista os dados de _item ficarão
  //inalterados. É uma boa pratica pois preserva os dados originais, para alterar os valores originais
  //deve ser feito através da classe products
  List<Product> get items => [..._items];
  List<Product> get itemsFavorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  //O que está comentado era para filtrar globalmente os produtos favoritos na aplicação
  //bool _showFavoriteOnly = false;

  // List<Product> get items {
  //   if (_showFavoriteOnly)
  //     return _items.where((element) => element.isFavorite).toList();
  //   else
  //     return [..._items];
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }
}
