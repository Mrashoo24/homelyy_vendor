import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyvendor/Home/home_page.dart';
import 'package:homelyvendor/Orders/orderpage.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:homelyvendor/main.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTotal extends StatefulWidget {
  final String orderId, wallet, total, delivery, savings, status,address;
  final VendorModel vendorDetails;
  const OrderTotal({
    Key key,
    this.orderId,
    this.delivery,
    this.savings,
    this.total,
    this.wallet,
    this.vendorDetails,
    this.status, this.address,
  }) : super(key: key);

  @override
  _OrderTotalState createState() => _OrderTotalState();
}

class _OrderTotalState extends State<OrderTotal> {
  var allApi = AllApi();
  @override
  Widget build(BuildContext context) {
    print('pending ${widget.status != 'Delivered'}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kgreen,
        title: const Text("Order Detail"),
      ),
      body: FutureBuilder<OrderModel>(
        future: allApi.getOrders(widget.orderId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: kgreen,),
            );
          } else {
            var orders = snapshot.data;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Text(
                        "Order Id: ${orders.orderId}",
                        style: GoogleFonts.basic(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: widget.status != 'Delivered' && widget.status != 'Cancelled',
                      child: ElevatedButton(
                        onPressed: () async {
                          if (widget.status == "Pending") {
                            ///////end
                            await allApi.putOrderStatus(
                              orderId: widget.orderId,
                              status: 'Accepted',
                            );
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Order Accepted'),
                                  content:
                                      Image.asset("assets/images/accepted.jpg"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.off(MyHomePage(
                                          vendorDetails: widget.vendorDetails,
                                        ));
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          if (widget.status == "Accepted") {
                            ///////end
                            await allApi.putOrderStatus(
                              orderId: widget.orderId,
                              status: 'Ready',
                            );
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Order Ready'),
                                  content:
                                      Image.asset("assets/images/accepted.jpg"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.off(MyHomePage(
                                          vendorDetails: widget.vendorDetails,
                                        ));
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          if (widget.status == "Ready") {
                            ///////end
                            await allApi.putOrderStatus(
                              orderId: widget.orderId,
                              status: 'Delivered',
                            );
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Order Delivered'),
                                  content:
                                  Image.asset("assets/images/accepted.jpg"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.off(MyHomePage(
                                          vendorDetails: widget.vendorDetails,
                                        ));
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(kgreen)),
                        child: widget.status == "Pending"
                            ? Text("ACCEPT",
                                style: GoogleFonts.basic(color: Colors.white))
                            : widget.status == "Accepted"
                                ? Text("READY",
                                    style: GoogleFonts.basic(color: Colors.white))
                                : widget.status == "Ready"
                                    ? Text("Delivered",
                                        style: GoogleFonts.basic(
                                            color: Colors.white))
                                    : Text(widget.status,
                                        style: GoogleFonts.basic(
                                            color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Visibility(
                      visible: widget.status == 'Pending',
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          onPressed: () async {

                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Do you want to cancel this order ?'),
                                  content: Image.asset(
                                      "assets/images/order_cancelled.png"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                       Get.back();
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () async {

                                        await allApi.putOrderStatus(
                                          orderId: widget.orderId,
                                          status: "Cancelled",
                                        );

                                        Get.off(MyHomePage(
                                          vendorDetails: widget.vendorDetails,
                                        ));
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );

                          },
                          child: Text("CANCEL",
                              style: GoogleFonts.basic(color: Colors.white))),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    InkWell(
                        onTap: () {
                          launch('tel:${orders.ref}');
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                color: Colors.blueGrey),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(FontAwesomeIcons.phoneAlt),
                                  Text(
                                    'Call Customer',
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                            ))),
                    const SizedBox(height: 50),
                     Text("Customer Address: ${widget.address}"),
                    const Divider(
                      thickness: 1,
                    ),
                    Text(
                      "Order Details",
                      style: GoogleFonts.basic(fontSize: 18),
                    ),
                    cartListNew(
                      img:orders.img,
                      cutprice: orders.cutprice,
                      discount: (double.parse(orders.price) -
                              double.parse(orders.cutprice))
                          .toString(),
                      itemNumber: orders.itemnumber,
                      ogcutprice: orders.ogcutprice,
                      price: orders.price,
                      ogprice: orders.ogprice,
                      quantity: orders.quantity,
                      requirement: orders.requirement,
                      title: orders.title,
                    ),
                    footer(
                      context,
                      orders.ogprice,
                      widget.wallet,
                      orders.discount,
                      widget.total,
                      widget.delivery,
                      widget.savings,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  footer(BuildContext context, String subTotal, String wallet, String discount,
      String total, String delivery, String savings) {
    return Card(
      margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
      elevation: 1,
      child: SizedBox(
        height: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            billRow("Sub Total", subTotal.toString()),
            const SizedBox(height: 8, width: 10),
            billRow("Total Savings", savings.toString()),
            // SizedBox(height: 8, width: 0),
            // billRow("Commision",
            //     ((double.parse(subTotal) * 1)).toString()),
            const SizedBox(height: 8, width: 0),
            billRow("Total", total.toString()),
            const SizedBox(height: 8, width: 0),
            const SizedBox(height: 8, width: 0),
          ],
        ),
      ),
    );
  }

  Row billRow(String text, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 30),
          child: Text(
            text,
            style: const TextStyle(color: Colors.blueGrey, fontSize: 18),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$",
                style:
                    TextStyle(color: Colors.deepOrange.shade700, fontSize: 14),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                price,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  cartListNew({
    String img,
    String title,
    String requirement,
    String price,
    String quantity,
    String itemNumber,
    String cutprice,
    String discount,
    String ogprice,
    String ogcutprice,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: createCartListItem(
            '${imgurl}/products/$img'  ,
            title,
            requirement,
            price,
            quantity,
            itemNumber,
            true,
            cutprice,
            discount,
            ogprice,
            ogcutprice,
            1,
            context,
            "recipe"),
      ),
    );
  }

  createCartListItem(
      String img,
      String title,
      String requirement,
      String price,
      String quantity,
      String itemnumber,
      bool discountVisibility,
      String cutprice,
      String discount,
      String ogprice,
      String ogcutprice,
      int index,
      BuildContext context,
      String recipe) {
    return Card(
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                      right: 8, left: 8, top: 8, bottom: 8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      color: Colors.white,
                      image: DecorationImage(image: NetworkImage(img))),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(right: 8, top: 4),
                          child: Text(
                            title,
                            maxLines: 2,
                            softWrap: true,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.blueGrey),
                          ),
                        ),
                        Text(
                          recipe,
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.blueGrey),
                        ),
                        Text(
                          "Quantity: $quantity",
                          style: const TextStyle(
                              color: Colors.green, fontSize: 18),
                        ),
                        const SizedBox(height: 6, width: 0),
                        Text(
                          "Special Requirement: $requirement",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        cutprice == ""
                                            ? ""
                                            : "\$${(int.parse(cutprice)).toString()}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.purple.shade400,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "\$$price",
                                        style: discountVisibility
                                            ? const TextStyle(
                                                fontSize: 14,
                                                color: Colors.blueGrey,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              )
                                            : TextStyle(
                                                fontSize: 16,
                                                color: Colors.purple.shade400,
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 100,
                )
              ],
            ),
          ),
          Visibility(
            visible: discountVisibility,
            child: Positioned(
              top: 10,
              left: 20,
              child: Container(
                width: 90,
                height: 25,
                child: Center(
                    child: Text(
                  "\$ $discount OFF",
                  style: GoogleFonts.arvo(fontSize: 12, color: Colors.white),
                )),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Colors.green,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
