import 'package:flutter/material.dart';

class CardItems extends StatelessWidget {
  const CardItems(
      {super.key,
      required this.id,
      required this.title,
      required this.price,
      required this.quantity});
  final String title;
  final String id;
  final double price;
  final int quantity;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      elevation: 5.0,
      child: ListTile(
        leading: CircleAvatar(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(
              child: Text('\$$price'),
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Text('Total : \$${price * quantity}'),
        trailing: Text('$quantity X'),
      ),
    );
  }
}
