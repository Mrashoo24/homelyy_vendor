import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homelyvendor/product/Restaurant/accepted_products.dart';
import 'package:homelyvendor/product/Restaurant/pending_products.dart';
import 'package:homelyvendor/product/Restaurant/rejected_products.dart';

class Products extends StatefulWidget {
  final String businessName, categoryId, vendorId;

  const Products({
    Key key,
    this.businessName,
    this.categoryId,
    this.vendorId,
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
        appBar: AppBar(
          title: const Text("Product List"),
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
            ),
            RejectedProducts(
              vendorId: widget.vendorId,
              categoryId: widget.categoryId,
            ),
            PendingProducts(
              vendorId: widget.vendorId,
              categoryId: widget.categoryId,
            ),
          ],
        ),
      ),
    );
  }
}
