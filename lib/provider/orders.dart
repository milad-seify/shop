import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.products,
      required this.amount,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  final String authToken;
  List<OrderItem> _orders = [];

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$authToken');
    final response = await http.get(url);
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadingItem = [];
    if (extractData == null) {
      return;
    }
    extractData.forEach((key, value) {
      loadingItem.add(
        OrderItem(
          id: key,
          amount: value['amount'],
          dateTime: DateTime.parse(value['dateTime']),
          products: (value['product'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadingItem.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = Uri.parse(
        'https://shop-9862d-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$authToken');
    final snapTime = DateTime.now();
    final response = await http.post(url,
        body: json.encode(
          {
            'dateTime': snapTime.toIso8601String(),
            'amount': total,
            'product': products
                .map(
                  (cartitem) => {
                    'id': cartitem.id,
                    'title': cartitem.title,
                    'price': cartitem.price,
                    'quantity': cartitem.quantity,
                  },
                )
                .toList(),
          },
        ));

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        products: products,
        amount: total,
        dateTime: DateTime.now(),
      ),
    );

//TODO : delete order and update order in dataBase

    notifyListeners();
  }
}
