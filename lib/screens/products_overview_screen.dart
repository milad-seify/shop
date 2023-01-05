import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/http_exception.dart';

import '../provider/products.dart';
import '../const_data.dart';
import '../widgets/products_gridview.dart';
import './cart_screen.dart';
import '../provider/cart.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

enum FiltersOptions { favoritesOnly, all }

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = '/product-overview-screen';
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _faveProduct = false;
  bool _initCheck = true;
  bool _loading = false;
  @override
  void initState() {
    //if you add listen:false you can use this  in initState()
    /* Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProduct();
    or
      Future.delayed(Duration.zero).then((_) {
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProduct();
    });*/
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initCheck) {
      setState(() {
        _loading = true;
      });
      fetchAndSet(context).then((value) {
        setState(() {
          _loading = false;
        });
      });

      _initCheck = false;
      super.didChangeDependencies();
    }
  }

  Future<void> fetchAndSet(BuildContext context) async {
    try {
      await Provider.of<ProductsProvider>(context).fetchAndSetProduct();
    } on HttpException catch (error) {
      errorDialogBox(context, error.toString());
    } catch (error) {
      errorDialogBox(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductsProvider>(context, listen: false);
    var popupMenuButton = PopupMenuButton(
      color: Colors.teal[100],
      shape: snackBarShape,
      onSelected: (FiltersOptions selectedValue) {
        setState(() {
          if (selectedValue == FiltersOptions.favoritesOnly) {
            _faveProduct = true;
            //  productData.favoritesProductsFilter();
          } else {
            _faveProduct = false;
            //    productData.allProductsFilter();
          }
        });
      },
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: FiltersOptions.favoritesOnly,
          child: Text(
            'Only Favorites',
            style: TextStyle(color: Colors.black),
          ),
        ),
        const PopupMenuItem(
          value: FiltersOptions.all,
          child: Text(
            'Show All',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          popupMenuButton,
          Consumer<Cart>(
            builder: ((context, cart, ch) => Badge(
                  value: cart.cardItemsLength.toString(),
                  color: const Color.fromARGB(255, 255, 17, 0),
                  child: ch as Widget,
                )),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      // bottomSheet:
      //     BottomSheet(onClosing: () {}, builder: ((context) => ))),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ProductsGridView(filterProduct: _faveProduct),
    );
  }
}

// Opacity(
//   opacity: _visible ? 1.0 : 0.0,
//   child: Text("Text!"),

// )
//It is better to use Visibility  widget  