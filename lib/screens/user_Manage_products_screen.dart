// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import '../widgets/user_manage_products_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_products_screen.dart';

class UserManageProductsScreen extends StatelessWidget {
  static const String routeName = './user_edit_products_screen';
  const UserManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productItems = Provider.of<ProductsProvider>(context).item;

    Future<void> _refreshProducts(BuildContext context) async {
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProduct();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductsScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: ListView.builder(
              itemCount: productItems.length,
              itemBuilder: (cxt, i) => Column(
                    children: [
                      UserProductItem(
                          id: productItems[i].id,
                          title: productItems[i].title,
                          imageUrl: productItems[i].imageUrl),
                      const Divider(),
                    ],
                  )),
        ),
      ),
    );
  }
}
