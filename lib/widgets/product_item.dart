import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/cart_provider.dart';
import 'package:shoppy/providers/product_provider.dart';
import 'package:shoppy/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ProductDetailsScreen.SCREEN_ID, arguments: product.id);
      },
      child: GridTile(
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.grey.shade500.withOpacity(0.5),
          leading: Consumer<Product>(
            builder: (BuildContext context, value, Widget child) {
              return IconButton(
                icon: Icon(product.isFavourite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavourite();
                },
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              cart.addItem(product);
            },
          ),
        ),
      ),
    );
  }
}
