import 'package:flutter/material.dart';
import 'package:shoppy/models/product.dart';
import 'package:shoppy/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailsScreen.SCREEN_ID, arguments: product.id);
      },
      child: GridTile(
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.grey.shade500.withOpacity(0.5),
          leading: Icon(Icons.add_shopping_cart),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          trailing: Icon(Icons.favorite),
        ),
      ),
    );
  }
}
