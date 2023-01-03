import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../const_data.dart';
import '../provider/product.dart';
import '../provider/products_provider.dart';

/* For short lists/ portrait-only apps, where only minimal scrolling might be needed, a ListView should be fine, since items won't scroll that far out of view (ListView has a certain threshold until which it will keep items in memory).
But for longer lists or apps that should work in landscape mode as well - or maybe just to be safe - you might want to use a Column (combined with SingleChildScrollView) instead. Since SingleChildScrollView doesn't clear widgets that scroll out of view, you are not in danger of losing user input in that case. */
class EditProductsScreen extends StatefulWidget {
  static const String routeName = './edit_products_screen';
  const EditProductsScreen({super.key});

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isInitial = true;
  bool _isLoading = false;
  Product _editedProducts = Product(
      id: 'null',
      title: '',
      description: '',
      imageUrl: '',
      price: 0,
      isFavorite: false);

  var _existedProduct = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //because didChangeDependencies recall more than ones unlike initState use _isInitial.
    if (_isInitial) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editedProducts = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId as String);
        _existedProduct = {
          'title': _editedProducts.title,
          'description': _editedProducts.description,
          'price': _editedProducts.price.toString(),
          'imageUrl': '',
        };
        //because we use controller for imageURl
        _imageUrlController.text = _editedProducts.imageUrl;
      }
    }
    _isInitial = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    //   _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus ||
        (!_imageUrlController.text.startsWith('http') &&
            !_imageUrlController.text.startsWith('https')) ||
        (!_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text.endsWith('.jpeg') &&
            !_imageUrlController.text.endsWith('.png') &&
            !_imageUrlController.text.endsWith('.webp'))) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();
    if (_editedProducts.id != 'null') {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProducts.id, _editedProducts);
      } catch (onError) {
        await showDialogSave(onError);
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProducts);
        // .catchError((onError) {
      } catch (onError) {
        await showDialogSave(onError);
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

//Don’t use helper functions for rendering UI
  Future<Null?> showDialogSave(Object onError) {
    return showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text(' An error occurred'),
              /* The cause of the error should not be displayed to the user, here we have done this for testing*/
              content: Text(onError.toString()),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Okay'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save_as_rounded),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          initialValue: _existedProduct['title'],
                          decoration:
                              textFormFieldEdit.copyWith(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (newValue) {
                            _editedProducts = Product(
                                id: _editedProducts.id,
                                title: newValue!,
                                description: _editedProducts.description,
                                imageUrl: _editedProducts.imageUrl,
                                price: _editedProducts.price,
                                isFavorite: _editedProducts.isFavorite);
                          },
                          validator: ((value) {
                            if (value!.isEmpty) {
                              return 'please provide a value';
                            }

                            return null;
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          initialValue: _existedProduct['price'],
                          decoration: textFormFieldEdit.copyWith(
                              labelText: 'Price',
                              hintText: 'Enter price of your product'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            //  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                          },
                          onSaved: (newValue) {
                            _editedProducts = Product(
                                id: _editedProducts.id,
                                title: _editedProducts.title,
                                description: _editedProducts.description,
                                imageUrl: _editedProducts.imageUrl,
                                price: double.parse(newValue!),
                                isFavorite: _editedProducts.isFavorite);
                          },
                          validator: ((value) {
                            if (value!.isEmpty) {
                              return 'please add price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'please enter valid number';
                            }
                            if (double.parse(value) <= 0) {
                              return 'please enter number greater than zero.';
                            }
                            return null;
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          initialValue: _existedProduct['description'],
                          decoration: textFormFieldEdit.copyWith(
                              label: const Icon(
                                Icons.description,
                                color: Colors.red,
                              ),
                              hintText: 'Enter Detail of Your Product'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          //  focusNode: _descriptionFocusNode,
                          onSaved: (newValue) {
                            _editedProducts = Product(
                                id: _editedProducts.id,
                                title: _editedProducts.title,
                                description: newValue!,
                                imageUrl: _editedProducts.imageUrl,
                                price: _editedProducts.price,
                                isFavorite: _editedProducts.isFavorite);
                          },
                          validator: ((value) {
                            if (value!.isEmpty) {
                              return 'please write description';
                            }
                            if (value.length < 10) {
                              return 'should be least 10 characters long';
                            }
                            return null;
                          }),
                        ),
                      ),
                      //     Divider(color: Colors.teal, thickness: 3.3 , ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            padding: const EdgeInsets.all(1.0),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: Colors.green.shade900,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Enter Image Url',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            width: 30.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: textFormFieldEdit.copyWith(
                                  labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (newValue) {
                                _editedProducts = Product(
                                    id: _editedProducts.id,
                                    title: _editedProducts.title,
                                    description: _editedProducts.description,
                                    imageUrl: newValue!,
                                    price: _editedProducts.price,
                                    isFavorite: _editedProducts.isFavorite);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter image url';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'please enter valid url http or https';
                                }
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('.png') &&
                                    !value.endsWith('.webp')) {
                                  return 'check format your image';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
