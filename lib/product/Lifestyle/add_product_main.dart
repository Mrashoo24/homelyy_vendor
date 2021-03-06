import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddProductMain extends StatefulWidget {
  final String vendorId;
  const AddProductMain({Key key, this.vendorId}) : super(key: key);

  @override
  _AddProductMainState createState() => _AddProductMainState();
}

class _AddProductMainState extends State<AddProductMain> {
  final _formKey = GlobalKey<FormState>();
  final _allApi = AllApi();

  var _productName = '';
  final _productId = 'PRODUCT' + DateTime.now().microsecond.toString();
  String _productCategory;
  var _productSubCategory = '';
  var _productDescription = '';
  var _vendorId = '';
  var _productPrice = '';
  var _productVarient = '';

  var _cutPrice = '';
  var _isLoading = false;
  File image;

  bool _trySubmit() {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();
    }
    return isValid;
  }

  Future _imagePicker() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
        backgroundColor: kgreen,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<List<CategoryModel>>(
              future: _allApi.getCategory(vendorId: widget.vendorId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final categoryList = snapshot.data;
                  return SingleChildScrollView(
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
                            // TextFormField(
                            //   decoration: const InputDecoration(
                            //     label: Text('Product Id'),
                            //     hintText: 'Enter id of the product',
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please enter id of the product';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _productId = value;
                            //   },
                            // ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.only(top: 8.0, bottom: 4.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: const Text('Select Category'),
                                  value: _productCategory,
                                  onChanged: (value) {
                                    setState(() {
                                      _productCategory = value;
                                    });
                                  },
                                  isExpanded: true,
                                  items: categoryList.map(
                                    (e) {
                                      return DropdownMenuItem(
                                        value: e.name,
                                        child: Text(e.name),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                            // TextFormField(
                            //   decoration: const InputDecoration(
                            //     label: Text('Category'),
                            //     hintText: 'Enter category of the product',
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please enter category of the product';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _productCategory = value;
                            //   },
                            // ),
                            // TextFormField(
                            //   decoration: const InputDecoration(
                            //     label: Text('Sub Category'),
                            //     hintText: 'Enter sub category of the product',
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please enter sub category of the product';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _productSubCategory = value;
                            //   },
                            // ),
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
                            // TextFormField(
                            //   decoration: const InputDecoration(
                            //     label: Text('Vendor Id'),
                            //     hintText: 'Enter the vendor\'s id',
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please enter vendor\'s id for the product';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _vendorId = value;
                            //   },
                            // ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.only(top: 8.0, bottom: 4.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: InkWell(
                                child: image != null
                                    ? Image.file(image)
                                    : const Text('Upload Image'),
                                onTap: _imagePicker,
                              ),
                            ),
                            // TextFormField(
                            //   decoration: const InputDecoration(
                            //     label: Text('Image'),
                            //     hintText: 'Upload image of the product',
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please upload image of the product';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _productImage = value;
                            //   },
                            // ),
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
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                _productPrice = value;
                              },
                            ),

                            // TextFormField(
                            //   decoration: const InputDecoration(
                            //     label: Text('Vareint Id'),
                            //     hintText: 'Enter varient id of the product',
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please enter varient id of the product';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _varientId = value;
                            //   },
                            // ),

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

                                if (canSubmit && image != null) {

                                  setState(() {
                                    _isLoading = !_isLoading;
                                  });

                                  int min = 100000; //min and max values act as your 6 digit range
                                  int max = 999999;
                                  var randomizer = new Random();
                                  var rNum = min + randomizer.nextInt(max - min);

                                  var lastDigits = rNum;


                                  final _varientId = 'VAR' + lastDigits.toString();

                                 var image1 = await _allApi.setImageProduct(image);
                                  setState(() {
                                    _isLoading = !_isLoading;
                                  });

                                  await _allApi.addProductMain(
                                    productName: _productName,
                                    productId: _productId,
                                    productCategory: _productCategory,
                                    productSubCategory: _productSubCategory,
                                    productDescription: _productDescription,
                                    vendorId: widget.vendorId,
                                    productImage: jsonDecode(image1),
                                    productPrice: _productPrice,
                                    productVarient: _varientId,
                                    varientId: _varientId,
                                    cutPrice: _cutPrice,
                                    requestDate:
                                    DateFormat('dd-MM-yyyy hh:mm a')
                                        .format(DateTime.now()),
                                  );

                                  await _allApi.putProductMainStatus(
                                    status: false,
                                    varientId: _varientId,
                                  );

                                  Fluttertoast.showToast(msg: 'Product Sent for Approval');

                                }
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
