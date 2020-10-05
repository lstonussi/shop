import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class Product extends ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavorite;
  bool isInCart = false;

  //Boa pratica usar um arquivo de constantes
  static const String _baseUrl = '${Constants.BASE_API_URL}';
  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    _toggleFavorite();
    try {
      final response = await http.put(
        '$_baseUrl/userFavorites/$userId/$id.json?auth=$token',
        body: jsonEncode(isFavorite),
      );
      //Caso de erro volta como estava
      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
      //Caso de qualer erro volta como estava
    } catch (e) {
      print(e);
      _toggleFavorite();
    }
  }
}
