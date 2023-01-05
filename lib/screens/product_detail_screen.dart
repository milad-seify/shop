import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../provider/product.dart';
import '../provider/products.dart';
import '../provider/cart.dart';
import '../widgets/image_url_show.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product_detail_screen';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;
    final productDetail = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(productDetail.title), actions: [
        IconButton(
            onPressed: () {
              cart.addCartItem(
                  productId, productDetail.title, productDetail.price);
            },
            icon: const Icon(Icons.add))
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                width: double.infinity,
                height: 300,
                child: ImageUrlShow(product: productDetail)),
            Text(
              '\$${productDetail.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 14.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 300,
              width: double.infinity,
              child: Text(
                productDetail.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
