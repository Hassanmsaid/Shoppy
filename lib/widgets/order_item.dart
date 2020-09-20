import 'package:flutter/material.dart';
import 'package:shoppy/providers/order_provider.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${widget.order.dateTime}'.substring(0, 19)),
            subtitle: Text('\$${widget.order.totalAmount.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          _expanded
              ? Container(
                  height: widget.order.products.length * 50.0,
                  child: ListView.builder(
                    itemCount: widget.order.products.length,
                    itemBuilder: (_, i) {
                      return Container(
                        color: Theme.of(context).accentColor,
                        margin: EdgeInsets.all(4),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            OrderProductItem(widget.order.products[i].title),
                            OrderProductItem(
                                '\$${widget.order.products[i].price.toStringAsFixed(2)}'),
                            OrderProductItem('x${widget.order.products[i].quantity}'),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class OrderProductItem extends StatelessWidget {
  final String text;

  OrderProductItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(child: Text(text)),
    );
  }
}
