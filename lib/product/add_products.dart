import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/Home/home_page.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:intl/intl.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _allApi = AllApi();
  var _productName = '';
  var _productId = '';
  var _productCategory = '';
  var _productSubCategory = '';
  var _productDescription = '';
  var _vendorId = '';
  var _productImage = '';
  var _productPrice = '';
  var _productVarient = '';
  var _varientId = '';
  var _cutPrice = '';
  var _isLoading = false;

  bool _trySubmit() {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Name'),
                          hintText: 'Enter name of the product',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter name of the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _productName = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Product Id'),
                          hintText: 'Enter id of the product',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter id of the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _productId = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Category'),
                          hintText: 'Enter category of the product',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter category of the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _productCategory = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Sub Category'),
                          hintText: 'Enter sub category of the product',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter sub category of the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _productSubCategory = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Description'),
                          hintText: 'Enter description of the product',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter description of the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _productDescription = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Vendor Id'),
                          hintText: 'Enter the vendor\'s id',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter vendor\'s id for the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _vendorId = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Image'),
                          hintText: 'Upload image of the product',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please upload image of the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _productImage = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Price'),
                          hintText: 'Enter price of the product',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter price of the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _productPrice = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Varient'),
                          hintText: 'Enter varient of the product',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter varient of the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _productVarient = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Vareint Id'),
                          hintText: 'Enter varient id of the product',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter varient id of the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _varientId = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Cut Price'),
                          hintText: 'Enter cut price of the product',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter cut price of the product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _cutPrice = value;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final canSubmit = _trySubmit();
                          if (canSubmit) {
                            setState(() {
                              _isLoading = !_isLoading;
                            });
                            await _allApi.addProduct(
                              productName: _productName,
                              productId: _productId,
                              productCategory: _productCategory,
                              productSubCategory: _productSubCategory,
                              productDescription: _productDescription,
                              vendorId: _vendorId,
                              productImage: _productImage,
                              productPrice: _productPrice,
                              productVarient: _productVarient,
                              varientId: _varientId,
                              cutPrice: _cutPrice,
                              requestDate: DateFormat('dd-MM-yyyy hh:mm a')
                                  .format(DateTime.now()),
                            );
                            setState(() {
                              _isLoading = !_isLoading;
                            });
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title:
                                      const Text('Product Sent for Approval'),
                                  content: const Text(
                                      'Your product will be added once admin approves it.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.offAll(const MyHomePage());
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
