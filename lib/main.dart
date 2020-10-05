import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/routes_app.dart';
import 'package:shop/views/auth_home_screen.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/orders_screen.dart';
import 'package:shop/views/product_detail.dart';
import 'package:shop/views/product_form_screen.dart';
import 'package:shop/views/products_screen.dart';

Future<void> main() async {
  //const bool inProduction = const bool.fromEnvironment('dart.vm.product');
  await DotEnv().load('.env');
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        //proxy provider consegue pegar dados de um provider e passar para outro,
        //é possivel pegar mais de um provider usando proxyprovider0,2,3
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (_, auth, previousProducts) =>
              Products(auth.token, auth.userId, previousProducts.items),
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, previousOrders) =>
              Orders(auth.token, previousOrders.items, auth.userId),
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          RoutesApp.AUTH_HOME: (_) => AuthOrHomeScreen(),
          RoutesApp.PRODUCT_DETAIL: (_) => ProductDetailScreen(),
          RoutesApp.CART: (_) => CartScreen(),
          RoutesApp.ORDERS: (_) => OrdersScreen(),
          RoutesApp.PRODUCTS: (_) => ProductsScreen(),
          RoutesApp.PRODUCTFORM: (_) => ProductFormScreen(),
        },
      ),
    );
  }
}
