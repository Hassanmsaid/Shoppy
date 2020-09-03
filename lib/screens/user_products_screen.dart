import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/products_provider.dart';
import 'package:shoppy/widgets/nav_drawer.dart';
import 'package:shoppy/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const SCREEN_ID = 'user_products_screen';

  Future _refresh(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).getAllProducts(all: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.SCREEN_ID);
            },
          ),
        ],
      ),
      drawer: NavDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, snapshot) => RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Consumer<ProductsProvider>(
                    builder: (ctx, productsData, _) => ListView.builder(
                      itemCount: productsData.productList.length,
                      itemBuilder: (_, i) => Column(
                        children: <Widget>[
                          UserProductItem(productsData.productList[i]),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
