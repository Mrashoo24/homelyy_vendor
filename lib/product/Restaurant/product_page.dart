import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/product/Restaurant/accepted_products.dart';
import 'package:homelyvendor/product/Restaurant/pending_products.dart';
import 'package:homelyvendor/product/Restaurant/rejected_products.dart';
import 'package:homelyvendor/product/add_products.dart';

import '../../components/model.dart';

class Products extends StatefulWidget {
  final String businessName, categoryId, vendorId, vendorType;
  final VendorModel vendorDetails;
  const Products({
    Key key,
    this.businessName,
    this.categoryId,
    this.vendorId,
    this.vendorType, this.vendorDetails,
  }) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: kgreen,
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(
              AddProduct(
                vendorId: widget.vendorId,
                vendorType: widget.vendorType,
                categoryId: widget.categoryId,
              ),
            );
          },
        ),
        appBar: AppBar(
          backgroundColor: kgreen,
          title: const Text("Product List",),
          bottom: const TabBar(

            tabs: [
              Tab(
                text: 'Accepted',
              ),
              Tab(
                text: 'Rejected',
              ),
              Tab(
                text: 'Pending',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AcceptedProducts(
              vendorId: widget.vendorId,
              categoryId: widget.categoryId,
                vendorDetails:widget.vendorDetails
            ),
            RejectedProducts(
              vendorId: widget.vendorId,
              categoryId: widget.categoryId,
                vendorDetails:widget.vendorDetails
            ),
            PendingProducts(
              vendorId: widget.vendorId,
              categoryId: widget.categoryId,
                vendorDetails:widget.vendorDetails
            ),
          ],
        ),
      ),
    );
  }
}
