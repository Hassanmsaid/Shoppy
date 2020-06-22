import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const SCREEN_ID = 'prod_details_screen';
  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
    );
  }
}
