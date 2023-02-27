import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../provider/product.dart';
import '../provider/products.dart';
import '../provider/cart.dart';

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                productDetail.title,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              background: Hero(
                tag: productDetail.id,
                child: Image.network(
                  productDetail.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            //  floating: true,
            actions: [
              IconButton(
                  onPressed: () {
                    //TODO : CHECK!
                    cart.addCartItem(
                        productId, productDetail.title, productDetail.price);
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  '\$${productDetail.price}',
                  textAlign: TextAlign.center,
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
                ),
                const SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
