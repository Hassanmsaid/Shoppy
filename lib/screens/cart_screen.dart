import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/cart_provider.dart';
import 'package:shoppy/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const SCREEN_ID = 'cart_screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: cart.productsCount,
                itemBuilder: (_, i) {
                  return CartItem(cart.getItems.values.toList()[i], cart.getItems.keys.toList()[i]);
                }),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  Text('Total: '),
                  Chip(label: Text('\$${cart.total}')),
                  Spacer(),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {},
                    child: Text('Check out'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
