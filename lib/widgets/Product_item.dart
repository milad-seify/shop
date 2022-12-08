import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../screens/product_detail_screen.dart';
import 'image_url_show.dart';
import '/const_data.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);

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
                      product.toggleFavoriteStatus();
                    },
                  )),
              //child: You can add whats u need in this widget thats Never Change , like TextWidget for title somewhere,this is a tiny optimization
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              softWrap: true,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            trailing: IconButton(
              tooltip: 'Add to Your Card',
              icon: const Icon(Icons.add_card),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {},
            ),
          ),
        ),
        child: GestureDetector(
          child: ImageUrlShow(product: product),
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
        ),
      ),
    );
  }
}
