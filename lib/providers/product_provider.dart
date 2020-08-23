import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shoppy/models/custom_exception.dart';

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
  bool isLoading = false;

  Future toggleFavourite() async {
//    final product = _productList.firstWhere((element) => element.id == id);
    isLoading = true;
    notifyListeners();
    final response = await http.patch('$baseUrl/$id.jsons',
        body: json.encode({
          "id": id,
          "title": title,
          "price": price,
          "description": description,
          "image_url": imageUrl,
          "is_favourite": !isFavourite,
        }));
    isLoading = false;

    if (response.statusCode == 200) {
      isFavourite = !isFavourite;
      notifyListeners();
    } else {
      notifyListeners();
      throw CustomExceptions('Failed!');
    }
  }
}
