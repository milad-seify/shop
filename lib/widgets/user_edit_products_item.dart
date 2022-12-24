import 'package:flutter/material.dart';

import '../const_data.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(
      {super.key, required this.title, required this.imageUrl});
  final String title;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: shapeCard,
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      trailing: SizedBox(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
