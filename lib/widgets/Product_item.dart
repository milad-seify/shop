import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context);

    return Card(
      //for only border radius use cliprrect
      elevation: 6.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        side: BorderSide(
          color: Colors.blueGrey,
          strokeAlign: StrokeAlign.outside,
        ),
      ),
      child: GridTile(
        footer: SizedBox(
          height: 37,
          child: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.7),
            leading: IconButton(
              tooltip: 'Add to Your favorite',
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).colorScheme.tertiary,
              onPressed: () {
                product.toggleFavoriteStatus();
              },
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
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
        ),
      ),
    );
  }
}
