import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyvendor/Orders/cancelled.dart';
import 'package:homelyvendor/Orders/delivered.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/model.dart';

class OrderHistory extends StatefulWidget {

  final VendorModel vendorDetails;

  const OrderHistory({Key key, this.vendorDetails}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();

}

class _OrderHistoryState extends State<OrderHistory> {

  var currentDate = DateTime.now();
  var currentEndDate = DateTime.now().add(Duration(days: 1));
  var commission = 0.0;

  _selectstartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: currentDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: currentEndDate.subtract(Duration(days: 1)),
    );
    if (picked != null && picked != currentDate)
      setState(() {
        currentDate = picked;
      });
  }

  _selectendDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: currentEndDate, // Refer step 1
      firstDate: currentDate.add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 1)),
    );
    if (picked != null && picked != currentEndDate)
      setState(() {
        currentEndDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Revenue"),backgroundColor: kgreen,),
        body: ListView(children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text("From Date"),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      _selectstartDate(context);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                            currentDate.toLocal().toString().split(' ')[0]),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green)),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text("To Date"),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      _selectendDate(context);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                            currentEndDate.toLocal().toString().split(' ')[0]),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green)),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder<List<OrderTotalModel>>(
            future: AllApi().getOrderTotaldate(widget.vendorDetails.vendorId,currentDate.toString(),currentEndDate.toString()),
            builder: (context, snapshot) {
              //
              // if (!snapshot.hasData) {
              //   return const Center(
              //     child: CircularProgressIndicator(color: kgreen,),
              //   );
              // }

              var orders = snapshot.data;
              print(orders);
             var deliveredorders = orders == null ? [] :orders.where((element) => element.status == 'Delivered').toList();
              var cancelledorders = orders == null ? [] :orders.where((element) => element.status == 'Cancelled').toList();
             var  totalEarnings = 0.0;
              var  totalEarningsOld = 0.0;
              var  totalEarningsNew = 0.0;

              print(deliveredorders.length);

              deliveredorders.forEach((element) {
                totalEarningsNew += double.parse(element.total) ;
              });

              deliveredorders.forEach((element) {
                totalEarningsOld += double.parse(element.total) ;
              });

              deliveredorders.forEach((element) {
                totalEarnings += double.parse(element.total) - (double.parse(element.total) * double.parse(widget.vendorDetails.commision));
              });

              var commision = totalEarnings - totalEarningsOld;

              return orders == null ? buildColumn(0, [], [],0,0) : buildColumn(totalEarnings, deliveredorders, cancelledorders,commision,totalEarningsNew);
            }
          )
        ]));
  }

  Column buildColumn(double totalEarnings, List<dynamic> deliveredorders, List<dynamic> cancelledorders,double totalEarningOld,double totalEarningOg) {
    return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text(
                      "Total Payments : ${widget.vendorDetails.symbol}${totalEarningOg.toPrecision(2)}",
                      style: GoogleFonts.basic(fontSize: 18),
                    )),
                Center(
                    child: Text(
                      "Homelly Commissions : ${widget.vendorDetails.symbol}${totalEarningOld.toPrecision(2)}",
                      style: GoogleFonts.basic(fontSize: 18),
                    )),
                Center(
                    child: Text(
                  "Total Earnings : ${widget.vendorDetails.symbol}${totalEarnings}",
                  style: GoogleFonts.basic(fontSize: 18),
                )),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 5.5,
                    children: [
                      InkWell(
                        child: Container(

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              color: Colors.green),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Total Orders Delivered",
                                  style: GoogleFonts.basic(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  deliveredorders.length.toString(),
                                  style: GoogleFonts.basic(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: () {

                         deliveredorders.isEmpty ? null : Get.to(Delivered(vendorDetails: widget.vendorDetails,orderTotal: deliveredorders,));

                        },
                      ),
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              color: Colors.red),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Total Orders Cancelled",
                                  style: GoogleFonts.basic(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  cancelledorders.length.toString(),
                                  style: GoogleFonts.basic(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: () {


                          cancelledorders.isEmpty ? null :    Get.to(Cancelled(vendorDetails: widget.vendorDetails,orderTotal: cancelledorders,));

                        },
                      )
                    ],
                  ),
                )
              ],
            );
  }
}
