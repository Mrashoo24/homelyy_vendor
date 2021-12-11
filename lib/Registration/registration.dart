import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/Home/home_page.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:image_picker/image_picker.dart';

class Registration extends StatefulWidget {
  const Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _allApi = AllApi();
  final _formKey = GlobalKey<FormState>();
  final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  var description = '',
      userName = '',
      shopName = '',
      address = '',
      email = '',
      password = '',
      type = '',
      phoneNumber = '';

  String cuisine;
  String category;
  File image;

  bool _trySubmit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState.validate();
    if (isValid) {
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
    return FutureBuilder(
      future: Future.wait([
        _allApi.getCuisine(),
        _allApi.getAllCategories(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<CuisineModel> cuisineList = snapshot.data[0];
        List<CategoryModel> categoryList = snapshot.data[1];
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sign up as a vendor'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Username'),
                        hintText: 'Enter your username',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userName = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        hintText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email';
                        } else if (!_emailRegExp.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Password'),
                        hintText: 'Set up your password',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        } else if (value.length < 6) {
                          return 'Password must be of minimum 6 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Description'),
                        hintText: 'Enter your description',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        description = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Address'),
                        hintText: 'Enter your address',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        address = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Type'),
                        hintText:
                            'Enter your shop type Eg. Restaurant, Lifestyle',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter shop type';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        type = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Shop Name'),
                        hintText: 'Enter your shop name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your shop name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        shopName = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Phone'),
                        hintText: 'Enter your phone number',
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length != 10) {
                          return 'Please enter valid phone number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        phoneNumber = value;
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
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text('Select Cuisine'),
                          value: cuisine,
                          onChanged: (value) {
                            setState(() {
                              cuisine = value;
                            });
                          },
                          isExpanded: true,
                          items: cuisineList.map(
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(12.0)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text('Select Category'),
                          value: category,
                          onChanged: (value) {
                            setState(() {
                              category = value;
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
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final canSubmit = _trySubmit();
                        if (canSubmit == false ||
                            category == null ||
                            cuisine == null ||
                            image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please complete registration details.'),
                            ),
                          );
                        } else {
                          await _allApi.addVendor(
                            description: description,
                            user: userName,
                            image: image.path,
                            name: shopName,
                            address: address,
                            email: email,
                            password: password,
                            type: type,
                            cuisine: cuisine,
                            category: category,
                            phoneNumber: phoneNumber,
                          );
                          var lastDigits = phoneNumber.substring(6);
                          var vendorId = 'VENDOR' + lastDigits;
                          await _allApi.putLocation(vendorId);
                          await _allApi.putNewVendorStatus(vendorId, false);
                          await _allApi.putNewVendorCuisCat(
                              vendorId, cuisine, category);
                          Get.back();
                        }
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
