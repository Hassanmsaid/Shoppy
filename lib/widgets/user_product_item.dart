import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/product_provider.dart';
import 'package:shoppy/providers/products_provider.dart';
import 'package:shoppy/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.title),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, EditProductScreen.SCREEN_ID, arguments: product);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  try {
                    await Provider.of<ProductsProvider>(context, listen: false)
                        .deleteProduct(product.id)
                        .then((value) => Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Deleted',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ))
                        .catchError((error) => Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Delete failed!',
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.red,
                              ),
                            ));
                  } catch (e) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
