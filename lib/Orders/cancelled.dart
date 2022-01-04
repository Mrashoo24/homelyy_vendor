import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'order_detail.dart';

class Cancelled extends StatefulWidget {
  final VendorModel vendorDetails;
  final List<OrderTotalModel> orderTotal;
  const Cancelled({Key key, this.vendorDetails, this.orderTotal}) : super(key: key);

  @override
  _CancelledState createState() => _CancelledState();
}

class _CancelledState extends State<Cancelled> {
  var allApi = AllApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<OrderTotalModel>>(
          future: allApi.getOrderStatus(status: "Cancelled",vid: widget.vendorDetails.vendorId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.isBlank) {
              return const Text(
                  'There are no orders being prepared at the moment.');
            } else {
              var orders = snapshot.data;
              return ListView.builder(
                itemCount: widget.orderTotal.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: createOrderListItem(
                      orderId: widget.orderTotal[index].orderId,
                      status: widget.orderTotal[index].status,
                      payment: widget.orderTotal[index].paymentMethod,
                      total: widget.orderTotal[index].total,
                      date: widget.orderTotal[index].date,
                      subTotal: widget.orderTotal[index].subtotal,
                      discount: widget.orderTotal[index].discount,
                      savings: widget.orderTotal[index].savings,
                      deliverynumber: widget.orderTotal[index].phone,
                      deliveryname: widget.orderTotal[index].name,address: widget.orderTotal[index].address
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget createOrderListItem({
    String orderId,
    String status,
    String date,
    String time,
    String payment,
    String total,
    String subTotal,
    String wallet,
    String discount,
    String savings,
    String name,
    String number,
    String email,
    String cuid,
    String reason,
    String businessName,
    GeoPoint userLocation,
    String deliverynumber,
    String deliveryname,address
  }) {

    return InkWell(
      onTap: () {
        Get.to(
          OrderTotal(
            orderId: orderId,
            delivery: "0",
            savings: savings,
            total: total,
            wallet: wallet,      vendorDetails:widget.vendorDetails,status: 'Cancelled',address: address,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ORDER ID: $orderId"),
                Text("Status: $status"),
              ],
            ),

            Text("Date: $date"),
            // Text("Time: $time"),
            Text("Customer Name: $deliveryname"),
            const SizedBox(

              height: 5,

            ),
            InkWell(
                onTap: () {
                  launch('tel:${deliverynumber}');
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Text("Total: $total"),
              ],
            ),
            const Divider(
              thickness: 2,
            )
          ],
        ),
      ),
    );
  }
}
