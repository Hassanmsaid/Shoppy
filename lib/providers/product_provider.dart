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

  static const baseUrl = 'https://shoppy-60a.firebaseio.com';
  bool isLoading = false;

  Future toggleFavourite(String token, String userId) async {
//    final product = _productList.firstWhere((element) => element.id == id);
    isLoading = true;
    notifyListeners();
    final response = await http.put('$baseUrl/userFavourites/$userId/$id.json?auth=$token',
        body: json.encode(
          !isFavourite,
        ));
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
