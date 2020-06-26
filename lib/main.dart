import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/cart_provider.dart';
import 'package:shoppy/providers/products_provider.dart';
import 'package:shoppy/screens/cart_screen.dart';
import 'package:shoppy/screens/product_details_screen.dart';
import 'package:shoppy/screens/products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.grey[850],
          accentColor: Colors.orange,
          fontFamily: 'Lato',
        ),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: ProductsScreen(),
        routes: {
          ProductDetailsScreen.SCREEN_ID: (context) => ProductDetailsScreen(),
          CartScreen.SCREEN_ID: (context) => CartScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
