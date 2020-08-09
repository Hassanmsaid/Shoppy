import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/cart_provider.dart';
import 'package:shoppy/providers/product_provider.dart';
import 'package:shoppy/providers/products_provider.dart';
import 'package:shoppy/screens/cart_screen.dart';
import 'package:shoppy/widgets/badge.dart';
import 'package:shoppy/widgets/nav_drawer.dart';
import 'package:shoppy/widgets/product_item.dart';

enum MenuOptions {
  All,
  Favourites,
}

class ProductsScreen extends StatefulWidget {
  static const SCREEN_ID = 'products_screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var showFavourites = false, _isLoading = false;

  Future _refresh() async {
    await Provider.of<ProductsProvider>(context, listen: false).getAllProducts();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false).getAllProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Shoppy'),
          actions: <Widget>[
            Consumer<CartProvider>(
              builder: (BuildContext context, CartProvider cart, Widget child) {
                return Badge(value: cart.productsCount.toString(), child: child);
              },
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.SCREEN_ID);
                },
              ),
            ),
            PopupMenuButton(
              onSelected: (value) {
                setState(() {
                  if (value == MenuOptions.All)
                    showFavourites = false;
                  else
                    showFavourites = true;
                });
              },
              itemBuilder: (_) => [
                PopupMenuItem(child: Text('All'), value: MenuOptions.All),
                PopupMenuItem(child: Text('Favourites'), value: MenuOptions.Favourites)
              ],
            ),
          ],
        ),
        drawer: NavDrawer(),
        body: RefreshIndicator(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ProductsGrid(showFavourites),
            onRefresh: _refresh));
  }
}

class ProductsGrid extends StatelessWidget {
  final bool showFavourites;

  ProductsGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    List<Product> products = showFavourites
        ? Provider.of<ProductsProvider>(context).favouriteList
        : Provider.of<ProductsProvider>(context).productList;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, i) {
          return ChangeNotifierProvider.value(value: products[i], child: ProductItem());
        });
  }
}
