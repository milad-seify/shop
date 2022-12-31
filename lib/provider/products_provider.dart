import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://www.iranpooshak.com/wp-content/uploads/2019/07/x-1.jpg',
      isFavorite: false,
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://titigoll.com/wp-content/uploads/2022/02/photo_2022-02-08_10-29-11.webp',
      isFavorite: false,
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://www.tiesplanet.com/images/plain-golden-yellow-chiffon-scarf-p13534-32997_medium.jpg',
      isFavorite: false,
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      isFavorite: false,
    ),
  ];

  // bool _showFavoritesOnly = false;

  List<Product> get item {
    // if (_showFavoritesOnly) {
    //   return _items.where((product) => product.isFavorite).toList();
    // } else {
    return [..._items];
    // }
  }

  List<Product> get favoritesItem {
    return _items.where((proFave) => proFave.isFavorite).toList();
  }

  // void favoritesProductsFilter() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void allProductsFilter() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return item.firstWhere((i) => i.id == id);
  }

  Future<void> addProduct(Product product) async {
    // final url = Uri.https(
    //     'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app',
    //     '/products.json');

    final url = Uri.parse(
        'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      print(json.decode(response.body)['name']);

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          isFavorite: product.isFavorite);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (onError) {
      print(onError);
      rethrow;
    }

    //without async
    // return http
    //     .post(
    //   url,
    //   body: json.encode({
    //     'title': product.title,
    //     'description': product.description,
    //     'imageUrl': product.imageUrl,
    //     'price': product.price,
    //     'isFavorite': product.isFavorite,
    //   }),
    // )
    //     .then((response) {
    //   print(json.decode(response.body)['name']);

    //   final newProduct = Product(
    //       id: json.decode(response.body)['name'],
    //       title: product.title,
    //       description: product.description,
    //       imageUrl: product.imageUrl,
    //       price: product.price,
    //       isFavorite: product.isFavorite);
    //   _items.insert(0, newProduct);
    //   notifyListeners();
    // }).catchError((onError) {
    //   print(onError);
    //   throw onError;
    // });
  }

  void updateProduct(String id, Product updateProduct) {
    final indexOfProduct = _items.indexWhere((element) => element.id == id);
    if (indexOfProduct >= 0) {
      _items[indexOfProduct] = updateProduct;
    } else {
      print('something wrong');
    }

    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  String imageUrl(String title) {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].title == title) {
        return _items[i].imageUrl;
      }
    }

    return 'Image Url Can\'t Find';
  }
}
