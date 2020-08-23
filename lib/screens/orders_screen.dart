import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/order_provider.dart';
import 'package:shoppy/widgets/nav_drawer.dart';
import 'package:shoppy/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const SCREEN_ID = 'orders_screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _loading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).getOrders().then((value) {
      setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: NavDrawer(),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(itemCount: orders.length, itemBuilder: (_, i) => OrderItem(orders[i])),
    );
  }
}
