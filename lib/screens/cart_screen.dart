import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart' show Cart;
import '../const_data.dart';
import '../widgets/card_item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart_screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 10.0,
            margin: const EdgeInsets.all(15),
            shape: borderCartScreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Total',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )),
                const Spacer(),
                Chip(
                  label: Text('\$${cart.totalAmount.toStringAsFixed(2)}'),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  padding: const EdgeInsets.all(11.0),
                ),
                const SizedBox(width: 5.0),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(3.0),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.amber.shade200),
                    shape: MaterialStateProperty.all(
                      borderCartScreen,
                    ),
                  ),
                  child: const Text('ORDER NOW'),
                ),
                const SizedBox(width: 6.0)
              ],
            ),
          ),
          const SizedBox(width: 6.0),
          Expanded(
              child: ListView.builder(
            itemCount: cart.cartItems.length,
            itemBuilder: ((ctx, i) {
              return CardItems(
                id: cart.cartItems.values.toList()[i].id.toString(),
                title: cart.cartItems.values.toList()[i].title,
                price: cart.cartItems.values.toList()[i].price,
                quantity: cart.cartItems.values.toList()[i].quantity,
              );
            }),
          ))
        ],
      ),
    );
  }
}
