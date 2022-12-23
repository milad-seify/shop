import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import '../widgets/edit_products_item.dart';
import '../widgets/app_drawer.dart';

class UserEditProductsScreen extends StatelessWidget {
  static const String routeName = './user_edit_products_screen';
  const UserEditProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productItems = Provider.of<ProductsProvider>(context).item;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Your Product'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(9),
        child: ListView.builder(
            itemCount: productItems.length,
            itemBuilder: (cxt, i) => Column(
                  children: [
                    EditProductItem(
                        title: productItems[i].title,
                        imageUrl: productItems[i].imageUrl),
                    const Divider(),
                  ],
                )),
      ),
    );
  }
}
