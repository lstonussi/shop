import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/utils/constants.dart';

class Products with ChangeNotifier {
  static const String _baseUrl = '${Constants.BASE_API_URL}/products';
  List<Product> _items = [];
  String _token;
  String _userId;

  Products([this._token, this._userId, this._items = const []]);

  //Como o spread adicionar uma lista em outra lista gerando outra lista os dados de _item ficarão
  //inalterados. É uma boa pratica pois preserva os dados originais, para alterar os valores originais
  //deve ser feito através da classe products
  List<Product> get items => [..._items];
  List<Product> get itemsFavorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get('$_baseUrl.json?auth=$_token');
    final favResponse = await http.get(
        '${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token');

    Map<String, dynamic> dados = json.decode(response.body);
    Map<String, dynamic> favMap =
        favResponse.body != null ? json.decode(favResponse.body) : null;
    _items.clear(); //Limpa a lista antes de adicionar para não duplicar

    if (dados != null) {
      dados.forEach((id, product) {
        _items.add(
          Product(
            id: id,
            description: product['description'],
            imageUrl: product['imageUrl'],
            price: product['price'],
            title: product['title'],
            //se o mao for nulo, é false. Caso não seja e o id não exista é falso.(retorno padrao)
            isFavorite: favMap == null ? false : favMap[id] ?? false,
          ),
        );
      });
    }
    notifyListeners();
  }

  Future addProduct(Product newProduct) async {
    final response = await http.post(
      '$_baseUrl.json?auth=$_token',
      body: jsonEncode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }),
    );

    _items.add(
      Product(
        id: json.decode(response.body)['name'],
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
        price: newProduct.price,
        title: newProduct.title,
      ),
    );
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items[index];

      //Exclusão otimista (mais rapido), excluir do app para dps excluir no servidor,
      //caso de algum erro, o item é incluido novamente
      _items.remove(product);
      notifyListeners();

      final response =
          await http.delete('$_baseUrl/${product.id}.json?auth=$_token');
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto');
      } else {
        _items.remove(product);
        notifyListeners();
      }
    }
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }
    final index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      await http.patch(
        '$_baseUrl/${product.id}.json?auth=$_token',
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  //Usa esse metodo para não ficar clonando a lista toda hora
  int get itemsCount {
    return _items.length;
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
