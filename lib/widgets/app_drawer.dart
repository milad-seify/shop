import 'package:flutter/material.dart';

import '../screens/orders_detail_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.amber[100],
      elevation: 5.0,
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Shop'),
            automaticallyImplyLeading: false,
            elevation: 5.0,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).popAndPushNamed('/');
            },
          ),
          const Divider(
            thickness: 1.0,
            color: Colors.orange,
            indent: 12.0,
            endIndent: 12.0,
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('payment'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(OrdersScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
