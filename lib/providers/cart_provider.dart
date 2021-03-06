import 'package:flutter/cupertino.dart';
import 'package:shoppy/models/cart.dart';
import 'package:shoppy/providers/product_provider.dart';

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
      _items.putIfAbsent(
          product.id,
          () => Cart(
              id: DateTime.now().toString(),
              title: product.title,
              price: product.price,
              quantity: 1));
    }
    notifyListeners();
  }

  int get productsCount => _items.length;

  double get total {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void deleteItem(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  void removeSingleItem(productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity == 1)
      deleteItem(productId);
    else
      _items[productId].quantity--;
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
