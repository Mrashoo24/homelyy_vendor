import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistory extends StatefulWidget {
  final String businessName;

  const OrderHistory({Key key, this.businessName}) : super(key: key);

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
        appBar: AppBar(title: Text("Revenue")),
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
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "Total Earnings : ₹${100}",
                style: GoogleFonts.basic(fontSize: 18),
              )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: GridView.count(
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    crossAxisCount: 1,
                    childAspectRatio: 3.5,
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
                                  0.toString(),
                                  style: GoogleFonts.basic(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          // Get.to(FilteredOrderScreen(
                          //   status: "Delivered",
                          //   businessName: widget.businessName,
                          //   currentDate: currentDate
                          //       .toLocal()
                          //       .toString()
                          //       .split(' ')[0],
                          //   currentEndDate: currentEndDate
                          //       .toLocal()
                          //       .toString()
                          //       .split(' ')[0],
                          //   commision: commission,
                          // ));
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
                                  0.toString(),
                                  style: GoogleFonts.basic(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          // Get.to(FilteredOrderScreen(
                          // status: "Cancelled",
                          // businessName: widget.businessName,
                          // currentDate: currentDate
                          //     .toLocal()
                          //     .toString()
                          //     .split(' ')[0],
                          // currentEndDate: currentEndDate
                          //     .toLocal()
                          //     .toString()
                          //     .split(' ')[0],
                          // commision: commission,
                          // ));
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ]));
  }
}
