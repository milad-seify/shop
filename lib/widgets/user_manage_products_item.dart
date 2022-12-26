import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import '../screens/edit_products_screen.dart';
import '../const_data.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.id});
  final String id;
  final String title;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    Provider.of<ProductsProvider>(context);
    return ListTile(
      tileColor: Colors.teal.shade200,
      contentPadding: const EdgeInsets.all(0),
      shape: shapeCard,
      //  leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      leading: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
          height: 70,
          width: 70,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black,
            decoration: TextDecoration.none,
            fontSize: 13,
            fontFamily: ''),
      ),
      trailing: SizedBox(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProduct(id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductsScreen.routeName, arguments: id);
              },
            )
          ],
        ),
      ),
    );
  }
}
