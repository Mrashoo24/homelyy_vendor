import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:homelyvendor/components/model.dart';

class PendingProducts extends StatefulWidget {
  final String categoryId, vendorId;
  final VendorModel vendorDetails;

  const PendingProducts({
    Key key,
    this.categoryId,
    this.vendorId, this.vendorDetails,
  }) : super(key: key);

  @override
  _PendingProductsState createState() => _PendingProductsState();
}

class _PendingProductsState extends State<PendingProducts> {
  final _allApi = AllApi();

  var editedCutprice = '';
  var editedprice = '';


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<FoodModel>>(
        future: _allApi.getProducts(
          categoryId: widget.categoryId,
          vendorId: widget.vendorId,
          verify: 'pending',
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.isEmpty) {
            return const Center(
              child: Text("No products to show."),
            );
          } else {
            var productList = snapshot.data;
            return ListView.builder(
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
                    discountVisibility: productList[index].cutprice == '0' ? false : true ,
                    discount: (int.parse(
                        productList[index].price) -
                        int.parse(
                            productList[index].cutprice))
                        .toString(),
                    productId: productList[index].productId,
                    recommendation: productList[index].recommendation == '1',
                  ),
                );
              },
            );
          }
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
    bool recommendation
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
            decoration:  BoxDecoration(
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
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    ),
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage('${imgurl}products/${img}'),
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
                                      Text(
                                        cutprice == "0"
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
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: CustomSwitch(
                                  //     value: stock,
                                  //     activeColor: Colors.blue,
                                  //     onChanged: (value) async {
                                  //       stock = !stock;
                                  //       await _allApi.putProductStatus(
                                  //         productId: productId,
                                  //         status: stock,
                                  //       );
                                  //     },
                                  //   ),
                                  // )
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
                        await  AllApi().removeProduct(foodId: productId,type: 'restro',vendorid: widget.vendorDetails.vendorId);
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
                                          await AllApi().putCutprice(foodId: productId,type: 'restro',body: {
                                            'cutprice': editedCutprice,'price': editedprice
                                          });
                                          setState1(() {
                                            isloading = false;
                                          });
                                          Get.back();

                                          setState(() {

                                          });

                                        }else{

                                          await AllApi().putCutprice(foodId: productId,type: 'restro',body: {
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

                                          await AllApi().putCutprice(foodId: productId,type: 'restro',body: {
                                            'cutprice': editedCutprice,'price': editedprice
                                          });
                                          setState1(() {
                                            isloading = false;
                                          });
                                          Get.back();

                                          setState(() {

                                          });
                                        }else{

                                          await AllApi().putCutprice(foodId: productId,type: 'restro',body: {
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
          ),],
      ),
    );
  }
}
