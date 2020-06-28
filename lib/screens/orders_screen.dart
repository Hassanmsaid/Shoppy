import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/order_provider.dart';
import 'package:shoppy/widgets/nav_drawer.dart';
import 'package:shoppy/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const SCREEN_ID = 'orders_screen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: NavDrawer(),
      body: ListView.builder(itemCount: orders.length, itemBuilder: (_, i) => OrderItem(orders[i])),
    );
  }
}
