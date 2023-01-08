import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/auth_screen.dart';
import '../provider/auth.dart';
import '../screens/orders_detail_screen.dart';
import '../screens/user_Manage_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.teal[200],
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
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('payment'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Manage Product'),
            onTap: () {
              Navigator.of(context)
                  .popAndPushNamed(UserManageProductsScreen.routeName);
            },
          ),
          Divider(
            thickness: 1.0,
            color: Colors.teal[900],
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('logout'),
            onTap: () {
              Navigator.of(context).pop;
              Navigator.of(context).pushReplacementNamed('/');

              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
