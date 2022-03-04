import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyvendor/Authentication/authentication.dart';
import 'package:homelyvendor/Membership/membership.dart';
import 'package:homelyvendor/Orders/cancelled.dart';
import 'package:homelyvendor/Orders/delivered.dart';
import 'package:homelyvendor/Orders/orderpage.dart';
import 'package:homelyvendor/Orders/preparing.dart';
import 'package:homelyvendor/Orders/ready.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/customswitch.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:homelyvendor/notifications/notifications.dart';
import 'package:homelyvendor/payment/orderhistory.dart';
import 'package:homelyvendor/product/add_products.dart';
import 'package:homelyvendor/product/category.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  final VendorModel vendorDetails;
  const MyHomePage({Key key, this.vendorDetails}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final allAPi = AllApi();
  final _appBarKey = GlobalKey();
  final _allApi = AllApi();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VendorModel>(
      future: _allApi.getVendor(email: widget.vendorDetails.email),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          var vendorDetails = snapshot.data;
          var lastPaymentDate =
              DateFormat('dd-MM-yyy').parse(vendorDetails.lastPaymentDate);
          var difference = lastPaymentDate.difference(DateTime.now()).inDays;
          var _shopStatus = vendorDetails.status;
          return vendorDetails.verify == "1"
              ? Scaffold(
                  drawer: Drawer(
                    child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Center(
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.monetization_on),
                                title: const Text('Payments'),
                                onTap: () => {
                                  Get.to(
                                     OrderHistory(vendorDetails: widget.vendorDetails,
                                        // businessName:
                                        // widget.businessName ?? businessName1,
                                        ),
                                  ),
                                },
                              ),
                              // if (vendorDetails.type == 'restro')
                              //   ListTile(
                              //     leading: const Icon(Icons.add),
                              //     title: const Text('Add Product'),
                              //     onTap: () => {
                              //       Get.to(AddProduct(
                              //         vendorId: widget.vendorDetails.vendorId,
                              //       ))
                              //     },
                              //   ),
                              // if (vendorDetails.type == 'lifestyle')
                              ListTile(
                                leading: const Icon(
                                    Icons.production_quantity_limits_rounded),
                                title: const Text('Product Management'),
                                onTap: () => {
                                  Get.to(
                                    () => CategoryPage(
                                      vendorId: widget.vendorDetails.vendorId,
                                      vendorType: widget.vendorDetails.type,
                                      vendorDetails :  widget.vendorDetails
                                    ),
                                  )
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.money),
                                title: const Text('Membership'),
                                onTap: () => {
                                  Get.to(
                                    Membership(
                                      vendorDetails: widget.vendorDetails,
                                    ),
                                  ),
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.door_back_door),
                                title: const Text('Logout'),
                                onTap: () => {
                                  SharedPreferences.getInstance().then((value) {
                                    value.clear().then((value) {
                                      Get.offAll(Authentication());
                                    });
                                  })
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                  appBar: AppBar(
                    key: _appBarKey,
                    title: const Text("Vendor")
                      ,backgroundColor: kgreen,
                    actions: [
                      if (difference > -30)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomSwitch(
                            value: _shopStatus,
                            activeColor: Colors.green,
                            onChanged: (value) async {
                              setState(() {
                                _shopStatus = value;
                              });
                              await allAPi.putShopStatus(
                                vendorId: widget.vendorDetails.vendorId,
                                status: _shopStatus,
                              ).then((value) {
                                _shopStatus ?Fluttertoast.showToast(msg: 'Shop is On Now') :   Fluttertoast.showToast(msg: 'Shop is Off Now');
                              });
                            },
                          ),
                        ),
                      const SizedBox(
                        width: 50,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Get.to(const NotificationPage());
                      //   },
                      //   child: Stack(
                      //     children: [
                      //       const Padding(
                      //         padding: EdgeInsets.all(8.0),
                      //         child: Icon(FontAwesomeIcons.bell),
                      //       ),
                      //       Align(
                      //         alignment: Alignment.centerLeft,
                      //         child: Text(
                      //           "3",
                      //           style: TextStyle(
                      //               color: Colors.green.shade900, fontSize: 18),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                  body: difference > -30
                      ? FutureBuilder(
                      future: allAPi.getOrderTotal(widget.vendorDetails.vendorId),
                      builder: (context,snapshot){

                        if(!snapshot.hasData){

                          return CircularProgressIndicator(color: kgreen,);
                        }

                        List<OrderTotalModel> listoforders= snapshot.requireData;

                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                children: <Widget>[
                                  buildDashCards(
                                      img: "assets/images/pending.png",
                                      press: () {
                                        Get.to(
                                           OrderPage(
                                            vendorDetails: widget.vendorDetails,
                                              orderTotal: listoforders.where((element) => element.status == 'Pending').toList(),
                                              // fromScreen: "Pending",
                                              // businessName:
                                              // widget.businessName ?? businessName1,
                                              ),
                                        );
                                      },
                                      count: listoforders.where((element) => element.status == 'Pending').toList().length.toString()),
                                  buildDashCards(
                                      img: "assets/images/processed.png",
                                      count: listoforders.where((element) => element.status == 'Accepted').toList().length.toString(),
                                      press: () {
                                        Get.to( Preparing( vendorDetails: widget.vendorDetails,orderTotal: listoforders.where((element) => element.status == 'Accepted').toList(),));
                                      }),
                                  buildDashCards(
                                      img: "assets/images/ready.png",
                                      count: listoforders.where((element) => element.status == 'Ready').toList().length.toString(),
                                      press: () {
                                        Get.to( Ready( vendorDetails: widget.vendorDetails,orderTotal: listoforders.where((element) => element.status == 'Ready').toList(),));
                                      }),
                                  buildDashCards(
                                      img: "assets/images/delivered.png",
                                      count: listoforders.where((element) => element.status == 'Delivered').toList().length.toString(),
                                      press: () {
                                        Get.to( Delivered(vendorDetails: widget.vendorDetails,orderTotal: listoforders.where((element) => element.status == 'Delivered').toList(),));
                                      }),
                                  buildDashCards(
                                    img: "assets/images/cancelled.png",
                                    count:  listoforders.where((element) => element.status == 'Cancelled').toList().length.toString(),
                                    press: () {
                                      Get.to(Cancelled(vendorDetails: widget.vendorDetails,orderTotal: listoforders.where((element) => element.status == 'Cancelled').toList(),));
                                    },
                                  ),
                                ],
                              ),
                            );
                        }
                      )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Card(
                              color: Colors.red.shade400,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              elevation: 5,
                              child: Container(
                                width: MediaQuery.of(context).size.width,

                                padding: const EdgeInsets.all(12.0),
                                child:  Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Your membership is expired\n Please Renew it from Membership section',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.white)
                                        ),
                                          onPressed: (){
                                        Get.to(Membership(vendorDetails: widget.vendorDetails,));
                                      }, child: Text('Continue',style: TextStyle(color: Colors.black),))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                )
              : Scaffold(
                body: Center(
            child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Card(
                  color: Colors.red.shade400,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    padding: const EdgeInsets.all(12.0),
                    child:  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Your application is under verification\nPlease wait or Contact us',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.green)
                              ),
                              onPressed: (){
                                if (Platform.isIOS) {
                                  return launch("whatsapp://wa.me/+919967706767/?text=${Uri.encodeFull('Query From ${widget.vendorDetails.email}')}");
                                } else {
                                  return launch("whatsapp://send?phone=+919967706767&text=${Uri.encodeFull("Query From ${widget.vendorDetails.email}")}");
                                }
                              }, child: Text('Connect on Whatsapp',style: TextStyle(color: Colors.white),))
                        ],
                      ),
                    ),
                  ),
                ),
            ),
          ),
              );
        }
      },
    );
  }

  Container buildDashCards({String img, Function press, String count}) {
    return Container(
      child: InkWell(
        child: Stack(
          children: [
            Image.asset(img),
            Positioned(
              right: 50,
              top: 90,
              child: Text(
                count,
                style: GoogleFonts.basic(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ),
        onTap: press,
      ),
    );
  }
}
