import 'package:flutter/cupertino.dart';
import 'package:shoppy/models/cart.dart';
import 'package:shoppy/providers/product.dart';

class CartProvider with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get getItems {
    return {..._items};
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (currentProduct) => Cart(
              id: currentProduct.id,
              title: currentProduct.title,
              price: currentProduct.price,
              quantity: currentProduct.quantity + 1));
    } else {
      _items.putIfAbsent(product.id,
          () => Cart(id: product.id, title: product.title, price: product.price, quantity: 1));
    }
    notifyListeners();
  }

  int get productsCount => _items.length;
}