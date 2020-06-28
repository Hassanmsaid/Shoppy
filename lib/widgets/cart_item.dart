import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/models/cart.dart';
import 'package:shoppy/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final Cart cartItem;
  final String prodId;

  CartItem(this.cartItem, this.prodId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(right: 12),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (key) {
        Provider.of<CartProvider>(context, listen: false).deleteItem(prodId);
      },
      confirmDismiss: (direction) => showDialog(
          builder: (ctx) => AlertDialog(
                title: Text('Remove item'),
                content: Text('Are you sure you want to remove ${cartItem.title} from cart?'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text('Yes, remove')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text('Cancel')),
                ],
              ),
          context: context),
      child: Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: Chip(
            label: Text('${cartItem.price}'),
          ),
          title: Text('${cartItem.title}'),
          subtitle: Text('Total: \$${cartItem.price * cartItem.quantity}'),
          trailing: Text('x${cartItem.quantity}'),
        ),
      ),
    );
  }
}
