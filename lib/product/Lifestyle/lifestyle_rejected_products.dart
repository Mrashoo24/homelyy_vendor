import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/model.dart';

import '../../components/constants.dart';
import 'lifestyle_products_page.dart';

class LifestyleRejectedProducts extends StatefulWidget {
  final String categoryId, vendorId, varientId;
  final VendorModel vendorDetails;
  const LifestyleRejectedProducts({
    Key key,
    this.categoryId,
    this.vendorId,
    this.varientId, this.vendorDetails,
  }) : super(key: key);

  @override
  _LifestyleRejectedProductsState createState() =>
      _LifestyleRejectedProductsState();
}

class _LifestyleRejectedProductsState extends State<LifestyleRejectedProducts> {
  var editedCutprice = '';
  var editedprice = '';
  final _allApi = AllApi();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:

      FutureBuilder<List<ProductMainModel>>(
        future: _allApi.getProductMain(
            vendorId: widget.vendorId,
            verify: 'pending',
          category: widget.categoryId
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
                  varientId: productList[index].varientId,
                  description: productList[index].description,
                  subCategory: productList[index].subCategory,
                  varient: productList[index].varient,
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
    String varientId,
    String description,
    String subCategory,
    String varient,
  }) {
    ProductMainModel productMainModel = ProductMainModel(
      category: category,
      cutprice: cutprice,
      description: description,
      image: img,
      name: title,
      price: price,
      status: stock,
      subCategory: subCategory,
      varient: varient,
      varientId: varientId,
      vendorId: widget.vendorId,
    );

    print('vid $discountVisibility');
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
                  margin:  EdgeInsets.only(
                    right: 8,
                    left: 8,
                    top: 8,
                    bottom: 8,
                  ),
                  width: 80,
                  height: 80,
                  decoration:   BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    ),
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage('https://thehomelyy.com/images/products/$img'),
                    ),
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
                                      Visibility(
                                        visible: discountVisibility,
                                        child: Text(
                                          "${widget.vendorDetails.symbol}${(int.parse(cutprice)).toString()}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.purple.shade400,
                                          ),
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
                                    child: ElevatedButton(
                                      child: const Text('View Products'),
                                      onPressed: () {
                                        Get.to(
                                              () => LifestyleProducts(
                                            vendorId: widget.vendorId,
                                            categoryId: widget.categoryId,
                                            varientId: varientId,
                                            productMainModel: productMainModel,
                                            vendorDetails: widget.vendorDetails,
                                          ),
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
                ),
                Column(
                  children: [
                    IconButton(onPressed: (){
                      Get.defaultDialog(title: 'Are you sure you want to delete this product ?',onConfirm:() async {
                        await  AllApi().removeProduct(foodId: productId,type: 'lifestyle',vendorid: widget.vendorDetails.vendorId);
                        Get.back();
                        setState(() {

                        });
                      },onCancel: (){
                        Get.back();
                      } );

                    }, icon:Icon(FontAwesomeIcons.trash)),

                    IconButton(onPressed: () async {

                      showDialog(context: context, builder: (context){
                        bool isloading = false;
                        return StatefulBuilder(

                            builder: (context, setState1) {
                              return  AlertDialog(
                                title: Text('Edit Price'),
                                content: Column(
                                  children: [
                                    TextFormField(

                                      onChanged: (value){
                                        setState(() {
                                          editedprice = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: price,
                                        label: Text('Price'),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    TextFormField(
                                      onChanged: (value){
                                        setState(() {
                                          editedCutprice = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          hintText: cutprice,
                                          label: Text('Cut Price')
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),

                                  ],
                                ),
                                actions: [
                                  isloading ? CircularProgressIndicator(color: kgreen,):  ElevatedButton(onPressed: (){
                                    Get.back();
                                  }, child: Text('Cancel'),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.grey)
                                    ),

                                  ),
                                  isloading ? CircularProgressIndicator(color: kgreen,) :   ElevatedButton(
                                    onPressed: () async {
                                      setState1(() {
                                        isloading = true;
                                      });
                                      if(editedCutprice != '' ){

                                        if(editedprice != '' ){
                                          await AllApi().putCutprice(foodId: productId,type: 'lifestyle',body: {
                                            'cutprice': editedCutprice,'price': editedprice
                                          });
                                          setState1(() {
                                            isloading = false;
                                          });
                                          Get.back();

                                          setState(() {

                                          });

                                        }else{

                                          await AllApi().putCutprice(foodId: productId,type: 'lifestyle',body: {
                                            'cutprice': editedCutprice,'price': price
                                          });
                                          setState1(() {
                                            isloading = false;
                                          });
                                          Get.back();

                                          setState(() {

                                          });
                                        }


                                      }

                                      if(editedprice != '' ){

                                        if(editedCutprice != '' ){

                                          await AllApi().putCutprice(foodId: productId,type: 'lifestyle',body: {
                                            'cutprice': editedCutprice,'price': editedprice
                                          });
                                          setState1(() {
                                            isloading = false;
                                          });
                                          Get.back();

                                          setState(() {

                                          });
                                        }else{

                                          await AllApi().putCutprice(foodId: productId,type: 'lifestyle',body: {
                                            'cutprice': cutprice,'price': editedprice
                                          });

                                          setState1(() {
                                            isloading = false;
                                          });
                                          Get.back();

                                          setState(() {

                                          });

                                        }



                                      }


                                    }, child: Text('Continue'),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(kgreen)
                                    ),
                                  )
                                ],
                              );
                            }
                        );
                      });




                    }, icon:Icon(FontAwesomeIcons.penAlt)),
                  ],
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
