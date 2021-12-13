import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/model.dart';

class AddProductVarient extends StatefulWidget {
  final ProductMainModel productMainModel;
  final String vendorId;
  const AddProductVarient({
    Key key,
    this.productMainModel,
    this.vendorId,
  }) : super(key: key);

  @override
  _AddProductVarientState createState() => _AddProductVarientState();
}

class _AddProductVarientState extends State<AddProductVarient> {
  final _formKey = GlobalKey<FormState>();
  final _allApi = AllApi();

  var _size = '';
  var _color = '';
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
        title: const Text('Add Product Varient'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Size'),
                    hintText: 'Enter size of the product varient',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter size';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _size = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Color'),
                    hintText: 'Enter color of the product varient',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter color';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _color = value;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final canSubmit = _trySubmit();
                    if (canSubmit) {
                      setState(() {
                        _isLoading = !_isLoading;
                      });
                      await _allApi.addProductVarient(
                        productName: widget.productMainModel.name,
                        productId:
                            'PRODUCT' + DateTime.now().microsecond.toString(),
                        productCategory: widget.productMainModel.category,
                        productSubCategory: widget.productMainModel.subCategory,
                        productDescription: widget.productMainModel.description,
                        vendorId: widget.vendorId,
                        productPrice: widget.productMainModel.price,
                        productVarient: widget.productMainModel.varient,
                        varientId:
                            'PRODUCT' + DateTime.now().microsecond.toString(),
                        cutPrice: widget.productMainModel.cutprice,
                      );

                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text('Product Sent for Approval'),
                            content: const Text(
                                'Your product will be added once admin approves it.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
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
