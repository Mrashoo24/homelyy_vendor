import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'order_detail.dart';

class Preparing extends StatefulWidget {
  final VendorModel vendorDetails;

  const Preparing({Key key, this.vendorDetails}) : super(key: key);

  @override
  _PreparingState createState() => _PreparingState();
}

class _PreparingState extends State<Preparing> {
  var allApi = AllApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),backgroundColor: kgreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<OrderTotalModel>>(
          future: allApi.getOrderStatus(status: "Preparing",vid: widget.vendorDetails.vendorId),
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
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: createOrderListItem(
                      orderId: orders[index].orderId,
                      status: orders[index].status,
                      payment: orders[index].paymentMethod,
                      total: orders[index].total,
                      date: orders[index].date,
                      subTotal: orders[index].subtotal,
                      discount: orders[index].discount,
                      savings: orders[index].savings,
                      deliverynumber: orders[index].phone,
                      deliveryname: orders[index].name,
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
    String deliveryname,
  }) {
    // print("commision1 ${widget.commision}");

    var earning = ((double.parse(subTotal) - double.parse(savings)) -
            ((double.parse(subTotal)) * 1))
        .toString();

    return InkWell(
      onTap: () {
        Get.to(
          OrderTotal(
            orderId: orderId,
            delivery: "0",
            savings: savings,
            total: total,
            wallet: wallet,
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
                  launch('tel:$deliverynumber');
                },
                child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Customer Number: $deliverynumber"),
                    ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Payment Method: $payment"),
                Text("Total: $earning"),
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
