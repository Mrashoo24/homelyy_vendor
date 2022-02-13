import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/map.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class Registration extends StatefulWidget {
  final LatLng latlng;
  final String address;
  final String type;

  const Registration({Key key, this.address, this.latlng, this.type}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _allApi = AllApi();
  final _formKey = GlobalKey<FormState>();
  final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");





  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  var userLatitude = "";
  var userLongitude = "";
  GeoPoint userGeoPoint;



  Future<LocationData> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Get.snackbar("Error",
            "'Location service is disabled. Please enable it to check-in.'");
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Get.snackbar("Error",
            "'Location service is disabled. Please enable it to check-in.'");
        return null;
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }

  var description = '',
      userName = '',
      shopName = '',
      address = '',
      email = '',
      password = '',
      phoneNumber = '';
  var types = ['Restaurant', 'Lifestyle'];

  String cuisine;
  String category;
  File image;

  var country;
  var symbol ;

  List countryList = [
    {'no': 1, 'keyword': 'India'},
    {'no': 2, 'keyword': 'Kuwait'},
    {'no': 3, 'keyword': 'Canada'},
    {'no': 4, 'keyword': 'UK'},
    {'no': 5, 'keyword': 'United States'},
    {'no': 6, 'keyword': 'Dubai'},
  ];

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
  void initState() {
    setState(() {
      userLatitude = widget.latlng == null ? ""  : (widget.latlng.latitude).toString();
      userLongitude = widget.latlng == null ? ""  : (widget.latlng.longitude).toString();
    });
    super.initState();
  }
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _allApi.getCuisine(widget.type),
        _allApi.getAllCategories(widget.type),
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
            backgroundColor: kgreen,
          ),
          body: SingleChildScrollView(
            child: loading ? Center(child: CircularProgressIndicator(color: Colors.green,)) : Container(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Please Note: A fee of \$2.99 is applicable on Approval of your Form',style: TextStyle(fontWeight: FontWeight.bold),),
                        )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 0.0, bottom: 4.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(12.0)),
                      child: InkWell(
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.mapMarkerAlt,color: kgreen,),
                            SizedBox(width: 20),
                            widget.address == null ? Text('Select Location') : Container(
                                width: Get.width*0.6,
                                child: Text(widget.address,overflow: TextOverflow.ellipsis,)
                            ),
                          ],
                        ),
                        onTap: (){
                          getLocation().then((value) {
                            Get.to(MapScreen(loc: LatLng(value.latitude,value.longitude),type : widget.type));
                          });
                        },
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        showCurrencyPicker(
                          context: context,
                          showFlag: true,
                          showCurrencyName: true,
                          showCurrencyCode: true,
                          onSelect: (Currency currency) {
                            print('Select currency: ${currency.name}');
                            setState(() {

                              country = currency.code;
                              symbol = currency.symbol;
                            });

                          },
                          favorite: ['INR'],
                        );
                      },
                      child: Container(
                        child: TextFormField(
                          enabled: false,
                          // The validator receives the text that the user has entered.
                          decoration: InputDecoration(
                            hintText:  country == "" || country == null ? "Your Country" : country,
                            labelText: country == "" || country == null ? "Your Country" : country,
                            // hintStyle: TextStyle(color: Colors.white30),
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            // errorText: isdiscountAvailable ? erroText : null
                          ),
                          validator: (value) {
                            return null;
                          },

                        ),
                      ),
                    ),
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
                      obscureText: true,
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
                        label: Text('Shop Description'),
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
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //     label: Text('Type'),
                    //     hintText:
                    //         'Enter your shop type Eg. Restaurant, Lifestyle',
                    //   ),
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Please enter shop type';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     type = value;
                    //   },
                    // ),
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
                        if (value.isEmpty) {
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
                          hint: widget.type == 'restro' ?Text('Select Cuisine') : Text('Select Parent Category'),
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
                      child: InkWell(
                        child: image != null
                            ? Image.file(image)
                            : const Text('Upload Logo'),
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
                            cuisine == null ||
                            image == null || widget.latlng == null) {

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please complete registration details.'),
                            ),
                          );

                        } else {

                          setState(() {
                            loading = true;
                          });

                          await _allApi.addVendor(


                            description: description,
                            user: userName,
                            image: image.path,
                            name: shopName,
                            address: address,
                            email: email,
                            password: password,
                            type: widget.type == 'Restaurant' ? 'restro' : 'lifestyle',
                            cuisine: cuisine,
                            phoneNumber: phoneNumber,
                            latitude: userLatitude,
                            longitude: userLongitude,
                            country: country,
                            symbol: symbol

                          );
                          var lastDigits = phoneNumber.substring(6);
                          var vendorId = 'VENDOR' + lastDigits;
                          await _allApi.putLocation(vendorId,userLatitude,
                              userLongitude);
                          await _allApi.putNewVendorStatus(vendorId, false);
                          await _allApi.putNewVendorCuisCat(
                              vendorId, cuisine, cuisine);
                          setState(() {
                            loading = false;
                          });
                          Get.back();
                          Get.snackbar('Successful', 'Your Process is under verification you will notify once approved',backgroundColor: Colors.white,colorText: Colors.black);


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
