import 'package:flutter/material.dart';

import '../provider/product.dart';

class ImageUrlShow extends StatelessWidget {
  const ImageUrlShow({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      product.imageUrl,
      loadingBuilder: ((context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator.adaptive(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      }),
      errorBuilder: (context, error, stackTrace) => Text(
        '${product.title} can`t load ',
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.red, backgroundColor: Colors.black, letterSpacing: 2),
      ),
      fit: BoxFit.contain,
    );
  }
}
