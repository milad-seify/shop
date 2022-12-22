import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/order_screen';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var orderData = Provider.of<Orders>(context);
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(title: const Text('Your Orders')),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(order: orderData.orders[i]),
      ),
    );
  }
}
