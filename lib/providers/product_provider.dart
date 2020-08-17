import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shoppy/models/custom_exception.dart';
import 'package:http/http.dart' as http;

class Product extends ChangeNotifier {
  String id, title, description, imageUrl;
  double price;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavourite = false});

  static const baseUrl = 'https://shoppy-60a.firebaseio.com/products';

  Future toggleFavourite() async {
//    final product = _productList.firstWhere((element) => element.id == id);
    final response = await http.patch('$baseUrl/$id.json',
        body: json.encode({
          "id": id,
          "title": title,
          "price": price,
          "description": description,
          "image_url": imageUrl,
          "is_favourite": !isFavourite,
        }));
    if (response.statusCode == 200) {
      isFavourite = !isFavourite;
    } else {
      throw CustomExceptions('Failed!');
    }
    notifyListeners();
  }
}
