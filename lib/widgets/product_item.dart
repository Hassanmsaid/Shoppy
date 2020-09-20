import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/auth_provider.dart';
import 'package:shoppy/providers/cart_provider.dart';
import 'package:shoppy/providers/product_provider.dart';
import 'package:shoppy/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final authData = Provider.of<AuthProvider>(context);

    return Consumer<Product>(
      builder: (BuildContext context, value, Widget child) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.SCREEN_ID, arguments: value.id);
          },
          child: GridTile(
            child: Hero(
              tag: value.id,
              child: Image.network(
                value.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.grey.shade500.withOpacity(0.5),
              leading: IconButton(
                icon: value.isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      )
                    : Icon(value.isFavourite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  //TODO fix error
                  value.toggleFavourite(authData.token, authData.userId).catchError(
                        (error) => Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
//                              'Error happened!',
                              error.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                },
              ),
              title: Text(
                value.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  cart.addItem(value);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${value.title} to cart'),
                      duration: Duration(seconds: 3),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeSingleItem(value.id);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
