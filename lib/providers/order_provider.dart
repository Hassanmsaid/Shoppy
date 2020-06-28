import 'package:flutter/material.dart';
import 'package:shoppy/models/cart.dart';

class Order {
  final String id;
  final double totalAmount;
  final List<Cart> products;
  final DateTime dateTime;

  Order(
      {@required this.id,
      @required this.totalAmount,
      @required this.products,
      @required this.dateTime});
}

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void createOrder(List<Cart> cartProducts, double total) {
    _orders.insert(
        0,
        Order(
            id: DateTime.now().toString(),
            totalAmount: total,
            products: cartProducts,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
