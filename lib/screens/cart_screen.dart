import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/orders_detail_screen.dart';

import '../provider/cart.dart' show Cart;
import '../const_data.dart';
import '../widgets/cart_item.dart';
import '../provider/orders.dart';

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
            color: Colors.white30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Total :',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )),
                const Spacer(),
                Chip(
                  elevation: 5.0,
                  label: Text('\$${cart.totalAmount.toStringAsFixed(2)}'),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  padding: const EdgeInsets.all(11.0),
                ),
                const SizedBox(width: 5.0),
                OrderButton(cart: cart),
                const SizedBox(width: 6.0)
              ],
            ),
          ),
          const SizedBox(width: 6.0),
          Expanded(
              child: ListView.builder(
            itemCount: cart.cartItems.length,
            itemBuilder: ((ctx, i) {
              return CartItems(
                id: cart.cartItems.values.toList()[i].id.toString(),
                productID: cart.cartItems.keys.toList()[i],
                title: cart.cartItems.values.toList()[i].title,
                price: cart.cartItems.values.toList()[i].price,
                quantity: cart.cartItems.values.toList()[i].quantity,
              );
            }),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.payment_outlined),
        onPressed: () {
          Navigator.of(context).popAndPushNamed(OrdersScreen.routeName);
        },
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(3.0),
        backgroundColor: MaterialStateProperty.all(Colors.amber.shade200),
        shape: MaterialStateProperty.all(
          borderCartScreen,
        ),
      ),
      onPressed: (widget.cart.cardItemsLength <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.cartItems.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });

              widget.cart.clear();
            },
      child: _isLoading
          ? const CircularProgressIndicator.adaptive(
              backgroundColor: Colors.teal,
              //strokeWidth: 50,
            )
          : const Text(
              'ORDER NOW',
            ),
    );
  }
}
