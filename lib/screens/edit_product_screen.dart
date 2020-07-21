import 'package:flutter/material.dart';
import 'package:shoppy/providers/product_provider.dart';

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
  String url = "";
  final _formKey = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: null, description: null, imageUrl: null, price: null);

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descFocus.dispose();
    _imgController.dispose();
    _imgFocus.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

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
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Product title', fillColor: Colors.indigo),
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocus),
                  onSaved: (val) => _editedProduct.title = val,
                  validator: (val) {
                    if (val.isEmpty) return 'Please enter title';
                    return null;
                  },
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Product price', fillColor: Colors.indigo),
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
                  textInputAction: TextInputAction.newline,
                  decoration:
                      InputDecoration(labelText: 'Product Description', fillColor: Colors.indigo),
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
                            url = val;
                          });
                        },
                        onSaved: (val) => _editedProduct.imageUrl = val,
                        validator: (val) {
                          if (val.isEmpty) return 'Please enter image url';
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
                              child: Image.network(url),
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
