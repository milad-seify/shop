import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  final String authToken;
  final String userId;

  ProductsProvider(
    this.userId,
    this.authToken,
    this._items,
  );

// Anything that is placed on the right hand side of the colon (:) has no access to this.
  ProductsProvider.initialProxy()
      : authToken = 'null',
        userId = 'null';

  List<Product> _items = [
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   isFavorite: false,
    // ),
  ];

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favoritesItem {
    return _items.where((proFave) => proFave.isFavorite).toList();
  }

  Product findById(String id) {
    return item.firstWhere((i) => i.id == id);
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    // String filterString =
    //     filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
//'orderBy=%22creatorId%22&equalTo=%22$userId%22'

    var url = Uri.parse(
        'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    if (filterByUser) {
      url = Uri.parse(
          'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"');
      _items = [];
    }

    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadingProduct = [];
      if (extractData == null) {
        return;
      }
      if (extractData['error'] != null) {
        throw HttpException(extractData['error']['message']);
      }
      url = Uri.parse(
          'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/userFavorite/$userId.json?auth=$authToken');
      final favResponse = await http.get(url);
      final favoriteData = json.decode(favResponse.body);

      extractData.forEach((key, value) {
        loadingProduct.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price'],
            isFavorite: favoriteData[key] == null
                ? false
                : favoriteData[key] ?? false));
      });

      for (int i = 0; i < _items.length; i++) {
        for (int j = 0; j < loadingProduct.length; j++) {
          if (_items[i].id == loadingProduct[j].id) {
            loadingProduct.removeAt(j);
          }
        }
      }
      _items.addAll(loadingProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  bool checkExistingProduct() {
    return true;
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );

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

  Future<void> updateProduct(String id, Product updateProduct) async {
    final indexOfProduct = _items.indexWhere((element) => element.id == id);
    if (indexOfProduct >= 0) {
      try {
        final url = Uri.parse(
            'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');
        await http.patch(url,
            body: json.encode({
              'title': updateProduct.title,
              'description': updateProduct.description,
              'imageUrl': updateProduct.imageUrl,
              'price': updateProduct.price,
            }));
        _items[indexOfProduct] = updateProduct;
      } catch (error) {
        rethrow;
      }
    } else {
      print('something wrong');
    }

    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final existingIndexProduct =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingIndexProduct];
    _items.removeAt(existingIndexProduct);
    notifyListeners();
    final response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(existingIndexProduct, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    } //If we have a problem, the continuation of the code will not be executed

    existingProduct = null;
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

  // void favoritesProductsFilter() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void allProductsFilter() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }