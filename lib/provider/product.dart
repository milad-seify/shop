import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

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

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final bool oldFav = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final url = Uri.parse(
          'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/userFavorite/$userId/$id.json?auth=$authToken');

      final response = await http.put(
        url,
        body: json.encode(isFavorite),
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
