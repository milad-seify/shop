import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../const_data.dart';
import '../screens/product_detail_screen.dart';

class CartItems extends StatelessWidget {
  const CartItems(
      {super.key,
      required this.id,
      required this.productID,
      required this.title,
      required this.price,
      required this.quantity});
  final String id;
  final String productID;
  final String title;
  final double price;
  final int quantity;
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          elevation: 5.0,
          shape: borderCartScreen,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          contentTextStyle: Theme.of(context).textTheme.subtitle2,
          title: const Text('Are You Sure ?'),
          content: const Text('Do you want remove the item from the cart?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No')),
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'))
          ],
        ),
      ),
      onDismissed: ((direction) => cart.removeItem(productID)),
      background: Container(
        padding: const EdgeInsets.only(right: 12.0),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const <Widget>[
              Text(
                'DELETE',
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.delete,
                color: Colors.white,
                size: 30.0,
              ),
            ]),
      ),
      child: InkWell(
        onLongPress: (() => Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: productID)),
        splashColor: Colors.red,
        child: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              elevation: 5.0,
              shape: borderCartScreen.copyWith(
                  side: const BorderSide(color: Colors.orange)),
              child: ListTile(
                leading: CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FittedBox(
                      child: Text('\$${price.toStringAsFixed(2)}'),
                    ),
                  ),
                ),
                title: Text(
                  title,
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle:
                    Text('Total : \$${(price * quantity).toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          cart.removeOneQuantity(productID);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                    IconButton(
                      onPressed: () {
                        //TODO : Go to Edit Screen.
                        cart.addCartItem(productID, title, price);
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                    ),
                    Text('$quantity X'),
                  ],
                ),
                // trailing: Wrap(
                //   spacing: -14.0,
                //   children: <Widget>[
                //     IconButton(
                //       icon: const Icon(Icons.delete),
                //       color: Colors.red,
                //       onPressed: () {},
                //     ),
                //     Text('$quantity X'),
                //  ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
