import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/order_screen';
  const OrdersScreen({super.key});

  //need use stateFullWidget
  //   bool _loading = false;
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _loading = true;
  //     });

  //         await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _loading = false;
  //     });
  //   });

  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) =>
                      OrderItem(order: orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
