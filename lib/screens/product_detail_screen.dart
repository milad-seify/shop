import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product_detail_screen';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;
    final Product productDetail =
        Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);

    return Scaffold(
      appBar: AppBar(title: Text(productDetail.title)),
    );
  }
}
