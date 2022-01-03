import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/Orders/order_detail.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPage extends StatefulWidget {
  final VendorModel vendorDetails;
  const OrderPage({Key key, this.vendorDetails}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var allApi = AllApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kgreen,
        title: const Text("Your Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<OrderTotalModel>>(
          future: allApi.getOrderStatus(vid:widget.vendorDetails.vendorId,status: 'Pending'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var orders = snapshot.data;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  // var orderId = product[(product.length - 1) - index]
                  // ["orderNumber"];
                  // var status =
                  // product[(product.length - 1) - index]["status"];
                  // var payment =
                  // product[(product.length - 1) - index]["payment"];
                  // var total =
                  // product[(product.length - 1) - index]["total"];
                  // var subTotal =
                  // product[(product.length - 1) - index]["subTotal"];
                  // var wallet =
                  // product[(product.length - 1) - index]["wallet"];
                  //
                  // var deliveryNumber =
                  // product[(product.length - 1) - index]
                  // ["deliveryboynumber"];
                  //
                  // var deliveryname =
                  // product[(product.length - 1) - index]
                  // ["deliveryboyname"];
                  //
                  // var discount = product[(product.length - 1) - index]
                  // ["discountTotal"];
                  // var savings =
                  // product[(product.length - 1) - index]["savings"];
                  // var date =
                  // product[(product.length - 1) - index]["date"];
                  // var time =
                  // product[(product.length - 1) - index]["time"];
                  // var name =
                  // product[(product.length - 1) - index]["name"];
                  // var number =
                  // product[(product.length - 1) - index]["number"];
                  // var cuid =
                  // product[(product.length - 1) - index]["uid"];
                  // GeoPoint userLocation =
                  // product[(product.length - 1) - index]
                  // ["userLocation"];
                  // var reason = status == "Cancelled"
                  //     ? product[product.length - 1]["reason"]
                  //     : "";
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
        // Get.to(() => OrderDetailScreen(
        //   userLocatiom: userLocation,
        //   businessName: businessName,
        //   id: orderId,
        //   status: status,
        //   subTotal: subTotal,
        //   wallet: wallet,
        //   discount: discount,
        //   savings: savings,
        //   total: total,
        //   delivery: "0",
        //   cuid: cuid,
        //   reason: reason,
        //   number: number,
        //   commision: 1,
        // ));
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
