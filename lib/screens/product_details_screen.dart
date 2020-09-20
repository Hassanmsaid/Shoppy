import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/auth_provider.dart';
import 'package:shoppy/providers/product_provider.dart';
import 'package:shoppy/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const SCREEN_ID = 'prod_details_screen';

  @override
  Widget build(BuildContext context) {
    print('prod details build');
    final prodId = ModalRoute.of(context).settings.arguments as String;
    final currentProduct = Provider.of<ProductsProvider>(context).getProductById(prodId);
    final authData = Provider.of<AuthProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(currentProduct.title),
      // ),
      floatingActionButton: Consumer<Product>(
        builder: (context, product, child) {
          return FloatingActionButton(
              child:
                  currentProduct.isFavourite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              onPressed: () {
                currentProduct.toggleFavourite(authData.token, authData.userId);
              });
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(currentProduct.title),
              background: Hero(
                tag: prodId,
                child: Image.network(
                  currentProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            currentProduct.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            color: Theme.of(context).accentColor,
                            padding: EdgeInsets.all(8),
                            child: Text(
                              '\$${currentProduct.price}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        currentProduct.description,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
