import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shoppy/providers/product_provider.dart';

class ProductsProvider with ChangeNotifier {
  static const url = 'https://shoppy-60a.firebaseio.com/products.json';

  List<Product> _productList = [
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  List<Product> get productList => [..._productList];

  List<Product> get favouriteList => _productList.where((element) => element.isFavourite).toList();

  Product getProductById(String id) {
    return _productList.firstWhere((element) => element.id == id);
  }

  Future getAllProducts() async {
    try {
      final response = await http.get(url);
      final fetchedProducts = json.decode(response.body) as Map<String, dynamic>;
      _productList.clear();
      fetchedProducts.forEach((key, value) {
        _productList.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            imageUrl: value['image_url'],
            price: value['price'],
            isFavourite: value['is_favourite']));
      });
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future addProduct(Product product) {
    return http
        .post(url,
            body: json.encode({
              "id": product.id,
              "title": product.title,
              "price": product.price,
              "description": product.description,
              "image_url": product.imageUrl,
              "is_favourite": product.isFavourite,
            }))
        .then((response) {
      product.id = json.decode(response.body)['name'];
      _productList.add(product);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  void updateProduct(Product updatedProduct) {
    final index = _productList.lastIndexWhere((element) => element.id == updatedProduct.id);
    _productList[index] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _productList.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
