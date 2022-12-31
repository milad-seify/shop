import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './provider/cart.dart';
import 'provider/orders.dart';
import './screens/product_detail_screen.dart';
import 'provider/products_provider.dart';
import './screens/cart_screen.dart';
import './screens/orders_detail_screen.dart';
import './screens/user_Manage_products_screen.dart';
import './screens/edit_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => ProductsProvider()),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider(
          create: ((context) => Orders()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop',
        theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.cyan,
            ).copyWith(
              secondary: Colors.orangeAccent,
              tertiary: Colors.red[400],
            ),
            textTheme: const TextTheme(
              subtitle1: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                overflow: TextOverflow.fade,
              ),
              subtitle2: TextStyle(
                fontFamily: 'Anton',
                color: Colors.white,
                fontSize: 12.0,
                decoration: TextDecoration.underline,
                overflow: TextOverflow.fade,
              ),
            ),
            scaffoldBackgroundColor: const Color.fromARGB(255, 207, 228, 226),
            appBarTheme: const AppBarTheme(color: Colors.teal)),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          UserManageProductsScreen.routeName: (context) =>
              const UserManageProductsScreen(),
          EditProductsScreen.routeName: (context) => EditProductsScreen(),
        },
      ),
    );
  }
}
