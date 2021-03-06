import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/cart_provider.dart';
import 'package:shoppy/providers/order_provider.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: <Widget>[
                  Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Chip(
                      label: Text('\$${cart.total.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 20))),
                  Spacer(),
                  CheckOutButton(cart: cart)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CheckOutButton extends StatefulWidget {
  CheckOutButton({
    this.cart,
  });

  final CartProvider cart;

  @override
  _CheckOutButtonState createState() => _CheckOutButtonState();
}

class _CheckOutButtonState extends State<CheckOutButton> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      onPressed: () {
        _loading
            ? null
            : Provider.of<OrderProvider>(context, listen: false)
                .createOrder(widget.cart.getItems.values.toList(), widget.cart.total);
        widget.cart.clear();
      },
      child: Text('Check out', style: TextStyle(fontSize: 20)),
    );
  }
}
