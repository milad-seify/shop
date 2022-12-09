import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/widgets/badge.dart';
// import 'package:provider/provider.dart';
// import 'package:shop/provider/products_provider.dart';

import '../widgets/products_gridveiw.dart';
import './cart_screen.dart';

enum FiltersOptions { favoritesOnly, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _faveProduct = false;

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOptions selectedValue) {
              setState(() {
                if (selectedValue == FiltersOptions.favoritesOnly) {
                  _faveProduct = true;
                  //  productData.favoritesProductsFilter();
                } else {
                  _faveProduct = false;
                  //    productData.allProductsFilter();
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FiltersOptions.favoritesOnly,
                child: Text(
                  ' Only Favorites',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const PopupMenuItem(
                value: FiltersOptions.all,
                child: Text(
                  'Show All',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: ((context, cart, ch) => Badge(
                  value: cart.cardItemsLength.toString(),
                  color: const Color.fromARGB(255, 255, 17, 0),
                  child: ch as Widget,
                )),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductsGridView(filterProduct: _faveProduct),
    );
  }
}
