import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const SCREEN_ID = 'prod_details_screen';

  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context).settings.arguments as String;
    final currentProduct = Provider.of<ProductsProvider>(context).getProductById(prodId);
    return Scaffold(
      appBar: AppBar(
        title: Text(currentProduct.title),
      ),
    );
  }
}
