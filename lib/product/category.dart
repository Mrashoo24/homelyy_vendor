import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:homelyvendor/product/productpage.dart';

class CategoryPage extends StatefulWidget {
  final String businessName;
  final String vendorId;
  const CategoryPage({
    Key key,
    this.businessName,
    this.vendorId,
  }) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _allApi = AllApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category List"),
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: _allApi.getCategory(
          vendorId: widget.vendorId,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var _categoryList = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: _categoryList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return createCatCard(
                  title: _categoryList[index].name,
                  stock: true,
                  indexcat: "0",
                  categoryId: _categoryList[index].catId,
                  vendorId: _categoryList[index].vendorId,
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget createCatCard({
    String title,
    bool stock,
    String indexcat,
    String categoryId,
    String vendorId,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: GoogleFonts.basic(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(Products(
                            businessName: widget.businessName,
                            categoryId: categoryId,
                            vendorId: vendorId,
                          ));
                        },
                        child: const Text("VIEW PRODUCTS"),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomSwitch(
                      value: stock,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        //
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
