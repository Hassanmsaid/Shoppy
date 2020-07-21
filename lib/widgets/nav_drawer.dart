import 'package:flutter/material.dart';
import 'package:shoppy/screens/orders_screen.dart';
import 'package:shoppy/screens/products_screen.dart';
import 'package:shoppy/screens/user_products_screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            height: 150,
            alignment: Alignment.center,
            child: Text(
              'Shoppy',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: Text('Products'),
            trailing: Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProductsScreen.SCREEN_ID);
            },
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            leading: Text('Orders'),
            trailing: Icon(Icons.receipt),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.SCREEN_ID);
            },
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            leading: Text('My Products'),
            trailing: Icon(Icons.widgets),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.SCREEN_ID);
            },
          ),
        ],
      ),
    );
  }
}
