import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
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
        backgroundColor: kgreen,
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


                      int min = 100000; //min and max values act as your 6 digit range
                      int max = 999999;
                      var randomizer = new Random();
                      var rNum = min + randomizer.nextInt(max - min);

                      var lastDigits = rNum;

                      final _productId = 'PRODUCT' + lastDigits.toString();

                      await _allApi.addProductVarient(
                        productName:
                            widget.productMainModel.name + _size + _color,
                        productId: _productId,
                        productCategory: widget.productMainModel.category,
                        productSubCategory: widget.productMainModel.subCategory,
                        productDescription: widget.productMainModel.description,
                        vendorId: widget.vendorId,
                        productPrice: widget.productMainModel.price,
                        productVarient: widget.productMainModel.varient,
                        varientId: widget.productMainModel.varientId,
                        cutPrice: widget.productMainModel.cutprice,
                      );

                      await _allApi.putProductVarientStatus(
                        productId: _productId,
                        status: false,
                        varientId: widget.productMainModel.varientId,
                      );
                      Get.snackbar('Success', 'Varient Added');

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
