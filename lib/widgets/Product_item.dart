import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
//import 'package:cached_network_image/cached_network_image.dart';

import '../provider/auth.dart';
import '../provider/product.dart';
import '../screens/product_detail_screen.dart';
//import 'image_url_show.dart';
import '/const_data.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    //final scaffold = ScaffoldMessenger.of(context);
    return Card(
      //for only border radius use cliprrect
      elevation: 6.0,
      shape: shapeCard,
      child: GridTile(
        footer: SizedBox(
          height: 37,
          child: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.7),
            leading: Consumer<Product>(
              //when just part of your widget need change you could add consumer for rebuild just this section
              builder: ((ctx, productChange, child) => IconButton(
                    tooltip: 'Add to Your favorite',
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Theme.of(context).colorScheme.tertiary,
                    onPressed: () {
                      product.toggleFavoriteStatus(
                          authData.token, authData.userId);
                      // .catchError(
                      //       (onError) => scaffold.showSnackBar(
                      //           SnackBar(content: Text('something missing'))),
                      //     );
                    },
                  )),
              //child: You can add whats u need in this widget thats Never Change , like TextWidget for title somewhere,this is a tiny optimization
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              softWrap: true,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            trailing: IconButton(
              tooltip: 'Add to Your Cart',
              icon: const Icon(Icons.add_card),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                cart.addCartItem(product.id, product.title, product.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.teal,
                    content: const Text('Added To Your Cart'),
                    duration: const Duration(seconds: 3),
                    elevation: 5.0,
                    shape: snackBarShape,
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeOneQuantity(product.id);
                        }),
                  ),
                );
              },
            ),
          ),
        ),
        child: GestureDetector(
          // child ;ImageUrlShow(product: product),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.contain,
            ),
          ),

          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
        ),
      ),
    );
  }
}



       //  CachedNetworkImage(
          //   fit: BoxFit.contain,
          //   imageUrl: product.imageUrl,
          //   progressIndicatorBuilder: (context, url, downloadProgress) =>
          //       CircularProgressIndicator(value: downloadProgress.progress),
          //   errorWidget: (context, url, error) => const Icon(
          //     Icons.error,
          //     color: Colors.red,
          //   ),
          // ),
          
// CachedNetworkImage(
//         imageUrl: "http://via.placeholder.com/350x150",
//         progressIndicatorBuilder: (context, url, downloadProgress) => 
//                 CircularProgressIndicator(value: downloadProgress.progress),
//         errorWidget: (context, url, error) => Icon(Icons.error),
//      ),
