import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/model.dart';

import '../Lifestyle/lifestyle_products_page.dart';

class AcceptedProducts extends StatefulWidget {
  final String categoryId, vendorId;
  final VendorModel vendorDetails;

  const AcceptedProducts({
    Key key,
    this.categoryId,
    this.vendorId, this.vendorDetails,
  }) : super(key: key);

  @override
  _AcceptedProductsState createState() => _AcceptedProductsState();
}

class _AcceptedProductsState extends State<AcceptedProducts> {
  final _allApi = AllApi();
  @override
  Widget build(BuildContext context) {
           return   Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<FoodModel>>(
        future: _allApi.getProducts(
            vendorId: widget.vendorId,
            categoryId: widget.categoryId,
            verify: 'pending'
        ),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
            var productList = snapshot.data;
            return  productList.isEmpty ? Container() :ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: createCartListItem(
                    category: productList[index].category,
                    context: context,
                    cutprice: productList[index].cutprice,
                    img: productList[index].image,
                    itemnumber: index.toString(),
                    price: productList[index].price,
                    stock: productList[index].status,
                    title: productList[index].name,
                    discountVisibility: productList[index].cutprice != '0',
                  ),
                );
              },
            );
        },
      ),
    );
  }

  createCartListItem({
    String img,
    String title,
    String price,
    String itemnumber,
    bool discountVisibility,
    String cutprice,
    String discount,
    String recipe,
    String category,
    int index,
    BuildContext context,
    bool stock,
    String productId,
  }) {
    return Card(
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    right: 8,
                    left: 8,
                    top: 8,
                    bottom: 8,
                  ),
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    ),
                    color: Colors.white,
                    // image: DecorationImage(
                    //   image: NetworkImage(img),
                    // ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                            right: 8,
                            top: 4,
                          ),
                          child: Text(
                            title,
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                          width: 0,
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
                                            : "${widget.vendorDetails.symbol}${(int.parse(cutprice)).toString()}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.purple.shade400,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${widget.vendorDetails.symbol}$price",
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomSwitch(
                                      value: stock,
                                      activeColor: Colors.blue,
                                      onChanged: (value) async {
                                        stock = !stock;
                                        await _allApi.putProductStatus(
                                          productId: productId,
                                          status: stock,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
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
        ],
      ),
    );
  }
}
