import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/product_provider.dart';
import 'package:shoppy/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const SCREEN_ID = 'edit_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descFocus = FocusNode();
  final _imgFocus = FocusNode();
  final _imgController = TextEditingController();
  String _imgUrl = "";
  final _formKey = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: null, description: null, imageUrl: null, price: null);
  var isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      final _product = ModalRoute.of(context).settings.arguments as Product;
      if (_product != null) {
        _editedProduct = _product;
        _imgController.text = _editedProduct.imageUrl;
        setState(() {
          _imgUrl = _editedProduct.imageUrl;
        });
      }
    }
    isInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descFocus.dispose();
    _imgController.dispose();
    _imgFocus.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    _isLoading = true;
    if (_editedProduct.id == null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Ops!'),
                content: Text('Something went wrong'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Ok'),
                  )
                ],
              );
            });
      }).then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      Provider.of<ProductsProvider>(context, listen: false).updateProduct(_editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  void updateImage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _editedProduct.title,
                        textInputAction: TextInputAction.next,
                        decoration:
                            InputDecoration(labelText: 'Product title', fillColor: Colors.indigo),
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocus),
                        onSaved: (val) => _editedProduct.title = val,
                        validator: (val) {
                          if (val.isEmpty) return 'Please enter title';
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue:
                            _editedProduct.price == null ? '' : _editedProduct.price.toString(),
                        textInputAction: TextInputAction.next,
                        decoration:
                            InputDecoration(labelText: 'Product price', fillColor: Colors.indigo),
                        keyboardType: TextInputType.numberWithOptions(signed: false),
                        focusNode: _priceFocus,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descFocus),
                        onSaved: (val) => _editedProduct.price = double.parse(val),
                        validator: (val) {
                          if (val.isEmpty) return 'Please enter price';
                          if (double.tryParse(val) == null || double.parse(val) <= 0)
                            return 'Enter a valid price';
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _editedProduct.description,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                            labelText: 'Product Description', fillColor: Colors.indigo),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        focusNode: _descFocus,
                        onSaved: (val) => _editedProduct.description = val,
                        validator: (val) {
                          if (val.isEmpty) return 'Please enter description';
                          if (val.length < 8) return 'Minimum length 8 chars';
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(labelText: 'Image Url'),
                              controller: _imgController,
                              keyboardType: TextInputType.url,
                              onChanged: (val) {
                                setState(() {
                                  _imgUrl = val;
                                });
                              },
                              onSaved: (val) => _editedProduct.imageUrl = val,
                              validator: (val) {
                                if (val.isEmpty) return 'Please enter image url';
                                //TODO add Regex validation
                                if (!val.startsWith('http') && !val.startsWith('https'))
                                  return 'Enter a valid url';
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: _imgController.text.isEmpty
                                ? Center(
                                    child: Text('Enter image url'),
                                  )
                                : FittedBox(
                                    child: Image.network(_imgUrl),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
