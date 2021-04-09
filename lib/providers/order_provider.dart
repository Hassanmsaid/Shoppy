import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  final String _token;
  String _userId;

  final baseUrl = 'https://shoppy-60a.firebaseio.com/orders';

  OrderProvider(this._token, this._userId, this._orders);

  void createOrder(List<Cart> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final response = await http.post(Uri.parse('$baseUrl/$_userId.json?auth=$_token'),
        body: json.encode({
          'amount': total,
          'date': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((product) => {
                    'id': product.id,
                    'title': product.title,
                    'quantity': product.quantity,
                    'price': product.price,
                  })
              .toList()
        }));
    if (response.statusCode == 200) {
      _orders.insert(
          0,
          Order(
              id: json.decode(response.body)['title'],
              totalAmount: total,
              products: cartProducts,
              dateTime: DateTime.now()));
    }
    notifyListeners();
  }

  Future getOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/$_userId.json?auth=$_token'));
    if (response.statusCode == 200) {
      List<Order> loadedOrders = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) return;
      data.forEach((key, value) {
        loadedOrders.add(Order(
          id: key,
          totalAmount: value['amount'],
          dateTime: DateTime.parse(value['date']),
          products: (value['products'] as List<dynamic>).map((item) {
            return Cart(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity']);
          }).toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
    }
  }
}
