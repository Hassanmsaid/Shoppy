import 'package:flutter/material.dart';

class Cart {
  final String id;
  final String title;
  final double price;
  int quantity;

  Cart({@required this.id, @required this.title, @required this.price, @required this.quantity});
}
