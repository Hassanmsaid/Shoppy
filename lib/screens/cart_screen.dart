import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  static const SCREEN_ID = 'cart_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Container(),
    );
  }
}
