import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:homelyvendor/product/Lifestyle/lifestyle_products_main_page.dart';
import 'package:homelyvendor/product/Restaurant/product_page.dart';
import 'package:image_picker/image_picker.dart';

class CategoryPage extends StatefulWidget {
  final String businessName;
  final String vendorId;
  final String vendorType;
  final VendorModel vendorDetails;
  const CategoryPage({
    Key key,
    this.businessName,
    this.vendorId,
    this.vendorType, this.vendorDetails,
  }) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _allApi = AllApi();
  final _formKey = GlobalKey<FormState>();
  var _categoryName = '';
  var _categoryType = '';


  bool _isLoading = false;
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

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState1) {
                  return AlertDialog(
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
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(top: 8.0, bottom: 4.0),
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
                            //     hintText: 'Upload image of the category',
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please upload image of the category';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _categoryImage = value;
                            //   },
                            // ),
                            // TextFormField(
                            //   decoration: const InputDecoration(
                            //     label: Text('Type'),
                            //     hintText: 'Enter type of the category',
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please enter type of the category';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _categoryType = value;
                            //   },
                            // ),
                            // TextFormField(
                            //   decoration: const InputDecoration(
                            //     label: Text('Category Id'),
                            //     hintText: 'Enter id of the category',
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please enter id of the category';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _categoryId = value;
                            //   },
                            // ),
                            // TextFormField(
                            //   decoration: const InputDecoration(
                            //     label: Text('Vendor Id'),
                            //     hintText: 'Enter id of the vendor',
                            //   ),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please enter id of the vendor';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _vendorId = value;
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                     _isLoading ? CircularProgressIndicator(color: kgreen,)  : TextButton(
                        onPressed: () async {
                          final canSumbit = _trySubmit();
                          if (canSumbit && image != null) {
                            setState(() {
                              _isLoading = true;
                            });

                          var iamge =  await _allApi.setImage(image);

                            int min = 100000; //min and max values act as your 6 digit range
                            int max = 999999;
                            var randomizer = new Random();
                            var rNum = min + randomizer.nextInt(max - min);

                            var lastDigits = rNum;

                            final _categoryId = 'CAT' + lastDigits.toString();

                            await _allApi.addCategory(
                              name: _categoryName,
                              image: jsonDecode(iamge),
                              type: _categoryType,
                              categoryId: _categoryId,
                              vendorId: widget.vendorId,
                            );

                            setState(() {

                              _isLoading = false;
                            });

                            Get.back();

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
                  );
                }
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
      appBar: AppBar(backgroundColor: kgreen,
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
            );}

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
                          if (widget.vendorType == 'restro') {
                            Get.to(
                              Products(
                                businessName: widget.businessName,
                                categoryId: categoryId,
                                vendorId: vendorId,
                                vendorType: widget.vendorType,
                                  vendorDetails:widget.vendorDetails
                              ),
                            );
                          } else {
                            Get.to(
                              LifestyleProductsMain(
                                categoryId: categoryId,
                                vendorId: vendorId,
                                vendorDetails:widget.vendorDetails
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kgreen)
                        ),
                        child: const Text("VIEW PRODUCTS"),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomSwitch(
                      value: stock,
                      activeColor: kgreen,
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
