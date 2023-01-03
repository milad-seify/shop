import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'products_provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isFavorite,
  });
  void _setFav(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final bool oldFav = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final url = Uri.parse(
          'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');

      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );
      print(response.statusCode);
      if (response.statusCode >= 400) {
        _setFav(oldFav);
      }
    } catch (error) {
      _setFav(oldFav);
      rethrow;
    }
  }
}
