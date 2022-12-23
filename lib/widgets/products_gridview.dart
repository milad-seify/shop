import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products_provider.dart';
import 'Product_item.dart';

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({super.key, required this.filterProduct});
  final bool filterProduct;

  @override
  Widget build(BuildContext context) {
    final ProductsProvider productData = Provider.of<ProductsProvider>(context);
    final List<Product> products =
        filterProduct ? productData.favoritesItem : productData.item;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: products.length,
      itemBuilder: ((context, i) => ChangeNotifierProvider.value(
            value: products[i],
            // create: (cxt) => products[i],
            child: const ProductItem(),
          )),
    );
  }
}
