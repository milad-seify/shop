import 'package:flutter/material.dart';

import '../widgets/products_gridveiw.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
      ),
      body: ProductsGridView(),
    );
  }
}
