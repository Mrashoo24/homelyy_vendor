import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:homelyvendor/product/Lifestyle/add_product_varient.dart';
import 'package:homelyvendor/product/Lifestyle/lifestyle_accepted_products.dart';
import 'package:homelyvendor/product/Lifestyle/lifestyle_pending_products.dart';
import 'package:homelyvendor/product/Lifestyle/lifestyle_rejected_products.dart';
import 'package:homelyvendor/product/add_products.dart';

class LifestyleProducts extends StatefulWidget {
  final String businessName, categoryId, vendorId, varientId;
  final ProductMainModel productMainModel;
  final VendorModel vendorDetails;

  const LifestyleProducts({
    Key key,
    this.businessName,
    this.categoryId,
    this.vendorId,
    this.varientId,
    this.productMainModel, this.vendorDetails,
  }) : super(key: key);

  @override
  _LifestyleProductsState createState() => _LifestyleProductsState();
}

class _LifestyleProductsState extends State<LifestyleProducts> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(
              () => AddProductVarient(
                productMainModel: widget.productMainModel,
                vendorId: widget.vendorId,
              ),
            );
          },
        ),
        appBar: AppBar(
          backgroundColor: kgreen,
          title: const Text("Product List"),
        ),
        body:   LifestyleRejectedProducts(
            vendorId: widget.vendorId,
            categoryId: widget.categoryId,
            varientId: widget.varientId,
            vendorDetails: widget.vendorDetails

        ),
      ),
    );
  }
}
