import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyvendor/Home/home_page.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:homelyvendor/product/productpage.dart';
import 'package:intent/category.dart';

class CategoryPage extends StatefulWidget {
  final String businessName;
  final String vendorId;
  const CategoryPage({
    Key key,
    this.businessName,
    this.vendorId,
  }) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _allApi = AllApi();
  final _formKey = GlobalKey<FormState>();
  var _categoryName = '';
  var _categoryImage = '';
  var _categoryType = '';
  var _categoryId = '';
  var _vendorId = '';
  bool _isLoading = false;

  bool _trySubmit() {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();
    }
    return isValid;
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Add Category'),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Name'),
                            hintText: 'Enter name of the category',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter name of the category';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _categoryName = value;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Image'),
                            hintText: 'Upload image of the category',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please upload image of the category';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _categoryImage = value;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Type'),
                            hintText: 'Enter type of the category',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter type of the category';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _categoryType = value;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Category Id'),
                            hintText: 'Enter id of the category',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter id of the category';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _categoryId = value;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Vendor Id'),
                            hintText: 'Enter id of the vendor',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter id of the vendor';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _vendorId = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      final canSumbit = _trySubmit();
                      if (canSumbit) {
                        setState(() {
                          _isLoading = true;
                        });
                        await _allApi.addCategory(
                          name: _categoryName,
                          image: _categoryImage,
                          type: _categoryType,
                          categoryId: _categoryId,
                          vendorId: _vendorId,
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        Get.back();
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Category Sent for Approval'),
                              content: const Text(
                                  'Your category will be added once admin approves it.'),
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
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(),
      appBar: AppBar(
        title: const Text("Category List"),
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: _allApi.getCategory(
          vendorId: widget.vendorId,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var _categoryList = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: _categoryList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return createCatCard(
                  title: _categoryList[index].name,
                  stock: true,
                  indexcat: "0",
                  categoryId: _categoryList[index].catId,
                  vendorId: _categoryList[index].vendorId,
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget createCatCard({
    String title,
    bool stock,
    String indexcat,
    String categoryId,
    String vendorId,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: GoogleFonts.basic(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(Products(
                            businessName: widget.businessName,
                            categoryId: categoryId,
                            vendorId: vendorId,
                          ));
                        },
                        child: const Text("VIEW PRODUCTS"),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomSwitch(
                      value: stock,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        //
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
