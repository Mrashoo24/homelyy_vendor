import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyvendor/Orders/cancelled.dart';
import 'package:homelyvendor/Orders/delivered.dart';
import 'package:homelyvendor/Orders/orderpage.dart';
import 'package:homelyvendor/Orders/preparing.dart';
import 'package:homelyvendor/Orders/ready.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:homelyvendor/notifications/notifications.dart';
import 'package:homelyvendor/payment/orderhistory.dart';
import 'package:homelyvendor/product/add_products.dart';
import 'package:homelyvendor/product/category.dart';

class MyHomePage extends StatefulWidget {
  final VendorModel vendorDetails;
  const MyHomePage({Key key, this.vendorDetails}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final allAPi = AllApi();
  final _appBarKey = GlobalKey();
  var _shopStatus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Center(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.grid_4x4),
                  title: const Text('Category List'),
                  onTap: () {
                    Get.to(
                      () => CategoryPage(
                        vendorId: widget.vendorDetails.vendorId,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Product List'),
                  onTap: () => {
                    Get.to(
                      const CategoryPage(
                          // businessName:
                          // (widget.businessName ?? businessName1),
                          ),
                    )
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on),
                  title: const Text('Payments'),
                  onTap: () => {
                    Get.to(
                      const OrderHistory(
                          // businessName:
                          // widget.businessName ?? businessName1,
                          ),
                    ),
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add Product'),
                  onTap: () => {Get.to(const AddProduct())},
                ),
                ListTile(
                  leading: const Icon(Icons.door_back_door),
                  title: const Text('Logout'),
                  onTap: () => {
                    // SharedPreferences.getInstance().then((value) {
                    //   value.clear().then((value) {
                    //     Get.offAll(FirstScreen());
                    //   });
                    // })
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        key: _appBarKey,
        title: const Text("Vendor"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomSwitch(
              value: _shopStatus,
              activeColor: Colors.green,
              onChanged: (value) async {
                setState(() {
                  _shopStatus = !_shopStatus;
                });
                await allAPi.putShopStatus(
                  vendorId: widget.vendorDetails.vendorId,
                  status: _shopStatus,
                );
              },
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          InkWell(
            onTap: () {
              Get.to(const NotificationPage());
            },
            child: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(FontAwesomeIcons.bell),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "3",
                    style:
                        TextStyle(color: Colors.green.shade900, fontSize: 18),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            buildDashCards(
                img: "assets/images/pending.png",
                press: () {
                  Get.to(
                    const OrderPage(
                        // fromScreen: "Pending",
                        // businessName:
                        // widget.businessName ?? businessName1,
                        ),
                  );
                },
                count: 1.toString()),
            buildDashCards(
                img: "assets/images/processed.png",
                count: 0.toString(),
                press: () {
                  Get.to(const Preparing());
                }),
            buildDashCards(
                img: "assets/images/ready.png",
                count: 0.toString(),
                press: () {
                  Get.to(const Ready());
                }),
            buildDashCards(
                img: "assets/images/delivered.png",
                count: 0.toString(),
                press: () {
                  Get.to(const Delivered());
                }),
            buildDashCards(
              img: "assets/images/cancelled.png",
              count: 0.toString(),
              press: () {
                Get.to(const Cancelled());
              },
            ),
          ],
        ),
      ),
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
