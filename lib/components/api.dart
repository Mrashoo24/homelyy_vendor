import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AllApi {
  Future<List<OrderTotalModel>>   getOrderTotal( String vid) async {
    var getOrderTotalUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getOrderTotalVendor?vid=$vid");
  
    var response = await http.get(getOrderTotalUrl);

    if (response.statusCode == 200) {
      
      List orderTotalList = json.decode(response.body);


      print('response of orders1 ${orderTotalList}');

      Iterable<OrderTotalModel> orderTotal = orderTotalList.map((e) {
        
        return OrderTotalModel().fromJson(e);
        
      });

      print(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()));



      print('response of ordderlist ${orderTotal}');

      List<OrderTotalModel> orderTotalList1 =  orderTotal.toList().where((element) {
        return element.date.substring(0,10) ==  DateFormat('yyyy-MM-dd').format(DateTime.now());
      }).toList();




      // orderTotal.toList().where((element) {
      //   return DateFormat("yyyy-MM-dd").parse(element.date).isAfter(
      //       DateFormat("yyyy-MM-dd")
      //           .parse(FromDate)
      //           .subtract(Duration(days: 1))) &&
      //       DateFormat("yyyy-MM-dd").parse(element['date']).isBefore(
      //           DateFormat("yyyy-MM-dd").parse(ToDate).add(Duration(days: 1)));
      // });

      // orderTotalList1.toList().sort((a,b){
      //   return DateFormat('yyyy-MM-dd HH:mm').format(DateFormat('dd/MM/yyyy HH:mm').parse(b.date)).compareTo(DateFormat('yyyy/MM/dd HH:mm').format(DateFormat('dd/MM/yyyy HH:mm').parse(a.date)));
      // });
      //
      // print(
      //     'DATE ${
      //         DateFormat('yyyy/MM/dd HH:mm').format(DateFormat('dd/MM/yyyy HH:mm').parse(orderTotal.toList()[0].date))
      //     }');
      // print(
      //     'orders ${
      //         orderTotalList1.toList()
      //     }');

      return orderTotalList1;
    } else {
      return null;
    }
  }

  Future<List<OrderTotalModel>>   getOrderTotaldate(String vid,from,to) async {
    var getOrderTotalUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getOrderTotalVendor?vid=$vid");

    var response = await http.get(getOrderTotalUrl);



    if (response.statusCode == 200) {

      List orderTotalList = json.decode(response.body);

      // print('from and todate ${from} $to');
      print('response of ordersdate ${orderTotalList}');

      Iterable<OrderTotalModel> orderTotal = orderTotalList.map((e) {

        return OrderTotalModel().fromJson(e);

      });

      print(DateFormat('yyyy-MM-dd HH:mm').parse(from));

      print(DateFormat('yyyy-MM-dd HH:mm').parse(to));


      print('got orfers $orderTotal');

     //  List<OrderTotalModel> orderTotalList1 =  orderTotal.toList().where((element) {
     //    print('datefilter ${element.date.substring(0,10)}');
     //    print('datef ilter ${DateFormat('yyyy-MM-dd').format(DateTime.now())}');
     //    print('boolwan ${element.date.substring(0,10) ==  DateFormat('yyyy-MM-dd').format(DateTime.now())}');
     //
     //    return element.date.substring(0,10) ==  DateFormat('yyyy-MM-dd').format(DateTime.now());
     //
     //  }).toList();
     //
     //  print('got orfersList $orderTotalList1');
     //
     //
     //  print(DateFormat("yyyy-MM-dd HH:mm")
     //      .parse(orderTotalList1[0].date));
     //
     //  print(DateFormat("yyyy-MM-dd HH:mm")
     //      .parse(orderTotalList1[0].date)
     //      .isAfter(DateFormat("yyyy-MM-dd HH:mm").parse(from)));
     //
     // print( DateFormat("yyyy-MM-dd HH:mm")
     //      .parse(orderTotalList1[0].date)
     //      .isBefore(DateFormat("yyyy-MM-dd HH:mm").parse(to)));


      List<OrderTotalModel>   orderTotalList2 = orderTotal.where((element) {
        return DateFormat("yyyy-MM-dd HH:mm")
            .parse(element.date)
            .isAfter(DateFormat("yyyy-MM-dd HH:mm").parse(from)) &&
            DateFormat("yyyy-MM-dd HH:mm")
                .parse(element.date)
                .isBefore(DateFormat("yyyy-MM-dd HH:mm").parse(to));
      }).toList();

      print('filtered = ${orderTotalList2}');



      return orderTotalList2;
    } else {
      return null;
    }
  }


  Future<OrderModel> getOrders(String orderId) async {
    var getOrdersUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getOrdersVendor?orderId=$orderId");
    var response = await http.get(getOrdersUrl);
    if (response.statusCode == 200) {
      Map<String, dynamic> ordersJson = json.decode(response.body);
      var orders = OrderModel().fromJson(ordersJson);
      return orders;
    } else {
      return null;
    }
  }

  Future<void> putOrderStatus(
      {@required String orderId, @required String status}) async {
    var putOrderStatusUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/putOrderStatusVendor?orderId=$orderId&status=$status");
    var response = await http.put(putOrderStatusUrl);
    if (response.statusCode == 200) {
      return;
    } else {
      return;
    }
  }

  Future<List<OrderTotalModel>> getOrderStatus(
      {@required String status,@required String vid}) async {
    var getOrderStatusUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getOrderStatusVendor?status=$status&vid=$vid");
    var response = await http.get(getOrderStatusUrl);
    if (response.statusCode == 200) {
      List orderTotalList = json.decode(response.body);
      Iterable<OrderTotalModel> orderTotal = orderTotalList.map((e) {
        return OrderTotalModel().fromJson(e);
      });


      return orderTotal.toList();
    } else {
      return null;
    }
  }

  Future<void> addProduct({
    @required String productName,
    @required String productId,
    @required String productCategory,
    @required String productSubCategory,
    @required String productDescription,
    @required String vendorId,
    @required String productImage,
    @required String productPrice,
    @required String cutPrice,
    @required String requestDate,
  }) async {
    var addProductUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/foodsadd");
    var response = await http.post(
      addProductUrl,
      body: {
        "category": productCategory,
        "subcategory": productSubCategory,
        "description": productDescription,
        "vendorid": vendorId,
        "foodid": productId,
        "name": productName,
        "image": productImage,
        "price": productPrice,
        "cutprice": cutPrice,
        "status": "false",
        "requestDate": requestDate,
        "verify": "pending",
        "recommendation": "0",
      },
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
  }

  Future<void> addProductVarient({
    @required String productName,
    @required String productId,
    @required String productCategory,
    @required String productSubCategory,
    @required String productDescription,
    @required String vendorId,
    @required String productPrice,
    @required String productVarient,
    @required String varientId,
    @required String cutPrice,
  }) async {
    var addProductUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/addProductVendor");
    var bo = {
      "category": productCategory,
      "subcategory": productSubCategory,
      "description": productDescription,
      "vendorid": vendorId,
      "productid": productId,
      "name": productName,
      "price": productPrice,
      "varient": productVarient,
      "cutprice": cutPrice,
      "status": "stock_status_pending",
      "varientid": varientId,
      "verify": "pending",
      "recommendation": "0",
    };
    print('body: $bo');
    var response = await http.post(
      addProductUrl,
      body: {

        "category": productCategory,
        "subcategory": productSubCategory,
        "description": productDescription,
        "vendorid": vendorId,
        "productid": productId,
        "name": productName,
        "price": productPrice,
        "varient": productVarient,
        "cutprice": cutPrice,
        "status": "stock_status_pending",
        "varientid": varientId,
        "verify": "pending",
        "recommendation": "0",

      },
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
  }

  Future<void> putProductVarientStatus(
      {String varientId, String productId, bool status}) async {
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyyadd/incoming_webhook/putProductVarientStatus?varientId=$varientId&productId=$productId&status=$status");
    var response = await http.put(url);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<void> addProductMain({
    @required String productName,
    @required String productId,
    @required String productCategory,
    @required String productSubCategory,
    @required String productDescription,
    @required String vendorId,
    @required String productImage,
    @required String productPrice,
    @required String productVarient,
    @required String varientId,
    @required String cutPrice,
    @required String requestDate,
  }) async {
    var addProductUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyyadd/incoming_webhook/addProductMain");

    var response = await http.post(
      addProductUrl,
      body: {
        "category": productCategory,
        "subcategory": productSubCategory,
        "description": productDescription,
        "vendorid": vendorId,
        "productid": productId,
        "name": productName,
        "image": productImage,
        "price": productPrice,
        "varient": productVarient,
        "cutprice": cutPrice,
        "status": 'false',
        "varientid": varientId,
        "requestDate": requestDate,
        "verify": "pending",
        "recommendation": "0",
      },
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
  }

  Future<void> putProductMainStatus({String varientId, bool status}) async {
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyyadd/incoming_webhook/putProductMainStatus?varientId=$varientId&status=$status");
    var response = await http.put(url);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<void> putProductFoodStatus({String foodId, bool status}) async {
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyyadd/incoming_webhook/putProductFoodStatus?foodId=$foodId&status=$status");
    var response = await http.put(url);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<VendorModel> getVendor({@required String email}) async {
    var getVendorUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getVendor?email=$email");
    var response = await http.get(getVendorUrl,headers: {'Content-Type': 'application/json'});
    if (response.body != "null") {
      Map<String, dynamic> vendor = json.decode(utf8.decode(response.bodyBytes));
      VendorModel vendorDetails = VendorModel().fromJson(vendor);
      return vendorDetails;
    } else {
      return null;
    }
  }

  Future<void> putShopStatus(
      {@required String vendorId, @required bool status}) async {
    var putShopStatusUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/putShopStatusVendor");
    var response = await http.put(putShopStatusUrl, body: {
      'vendorId': vendorId,
      'status': status.toString(),
    });
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<List<CategoryModel>> getCategory({@required String vendorId}) async {
    var getCategoryUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getCategoryVendor?vendorId=$vendorId");
    var response = await http.get(getCategoryUrl);
    if (response.body != "null") {
      List categoryList = json.decode(response.body);
      Iterable<CategoryModel> category = categoryList.map((e) {
        return CategoryModel().fromJson(e);
      });
      return category.toList();
    } else {
      return [];
    }
  }

  Future<List<FoodModel>> getProducts({
    @required String vendorId,
    @required String categoryId,
    @required String verify,
  }) async {
    var getProductsUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getProductsVendor?vendorId=$vendorId&categoryId=$categoryId&verify=$verify");
    var response = await http.get(getProductsUrl);
    if (response.body != "null") {
      List productList = json.decode(response.body);
      Iterable<FoodModel> products = productList.map((e) {
        return FoodModel().fromJson(e);
      });
      return products.toList();
    } else {
      return null;
    }
  }

  Future getProductsVarient({
    @required String varientId,
    @required String verify,
  }) async {
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/varientProductGet?varientid=$varientId&verify=$verify");
    print(url);
    var response = await http.get(url);

    var body = json.decode(response.body);


    if (body != "[]") {
      List productList = json.decode(response.body);

      Iterable<ProductModel> products = productList.map((e) {
        return ProductModel().fromJson(e);
      });

      print('podfuct ${productList}');
      return productList;
    } else {
      return [];
    }
  }

  Future<void> putProductStatus(
      {@required String productId, @required bool status}) async {
    var putProductStatusUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/putProductStatusVendor?productId=$productId&status=$status");
    var response = await http.put(putProductStatusUrl);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<void> addCategory({
    @required String name,
    @required String image,
    @required String type,
    @required String categoryId,
    @required String vendorId,
  }) async {
    var addCategoryUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/addCategoryVendor");
    var response = await http.post(addCategoryUrl, body: {
      'name': name,
      'image': image,
      // 'type': type,
      'catid': categoryId,
      'vendorid': vendorId,
      'status': 'Pending',
      'date': DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now()),
      'verify': '0',
    });
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<void> putToken(
      {@required String vendorId, @required String token}) async {
    var putTokenUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/putTokenVendor?vendorId=$vendorId&token=$token");
    var response = await http.put(putTokenUrl);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<void> putLastPaymentDate(
      {@required String vendorId, @required paymentDate}) async {
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/putLastPaymentDate?vendorId=$vendorId&paymentDate=$paymentDate");
    var response = await http.put(url);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<List<CuisineModel>> getCuisine(String type) async {
    var getCuisineUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getCuisines?type=$type");
    var response = await http.get(getCuisineUrl);

    if (response.body != "null") {
      List cuisineList = json.decode(response.body);
      Iterable<CuisineModel> cuisine = cuisineList.map((e) {
        return CuisineModel().fromJson(e);
      });
      print('finale ${cuisine.toList()}');

      return cuisine.toList();
    } else {
      return null;
    }
  }

  Future<List<CategoryModel>> getAllCategories(String type) async {
    var getCategoryUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getAllCategories?type=$type");
    var response = await http.get(getCategoryUrl);

    print('url $getCategoryUrl');
    print('url ${response.body}');

    if (response.body != "null") {
      List categoryList = json.decode(response.body);
      Iterable<CategoryModel> category = categoryList.map((e) {
        return CategoryModel().fromJson(e);
      });
      print('finale ${category.toList()}');
      return category.toList();
    } else {
      return null;
    }
  }

  Future<void> addVendor({
    @required String description,
    @required String user,
    @required String image,
    @required String name,
    @required String address,
    @required String email,
    @required String password,
    @required String type,
    @required String cuisine,
    @required String category,
    @required String phoneNumber,
    @required String latitude,
    @required String longitude,
    @required String country,
    @required String symbol,
    lastDigits,

  }) async {

    print('image aagyai');

    var date = DateFormat('dd-MM-yyyy').format(

      DateTime.now().subtract(
        const Duration(days: 30),
      ),

    );



    var url = Uri.parse(

        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/newVendor"

    );


    var response = await http.post(url, body: {

      'description': description,
      'user': user,
      'inPromotion': '0',
      'image': image,
      'vendorid': 'VENDOR$lastDigits',
      'name': name,
      'address': address,
      'email': email,
      'password': password,
      'type': type,
      'rating': '0',
      'cuisine': '[cuisine]',
      'phoneNumber':phoneNumber,
      'verify': '0',
      'status': 'false',
      'last_payment_date': '31-03-2022',
      'country': country,
      'symbol':symbol,
      'commision':'0.10'

    }
    );

    if(response.statusCode == 200){


      }

    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<void> putLocation(String vendorId,String latitude,String longitude) async {
    // LocationData locationData = await Location().getLocation();
    var lat = latitude; //locationData.latitude;
    var lon = longitude; //locationData.longitude;
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/putLocationVendor?vendorId=$vendorId&lat=$lat&lon=$lon");
    var response = await http.put(url);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<void> putNewVendorStatus(String vendorId, bool status) async {
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/putNewVendorStatus?vendorId=$vendorId&status=$status");
    var response = await http.put(url);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<void> putCuisine(map) async {
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyyadd/incoming_webhook/postCuisine");
    var response = await http.post(url,body: map);
    if (response.statusCode != 200) {
      return response.statusCode;
    }
  }

  Future<void> putNewVendorCuisCat(
      String vendorId, String cuisine, String category) async {
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/putNewVendorCuisCat?vendorId=$vendorId&cuisine=$cuisine&category=$category");
    var response = await http.put(url);
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<String> setImage(File file) async {

    print('its working $file');

    var url = Uri.parse("https://thehomelyy.com/category-post.php");

    String value1 = "";

    var request = http.MultipartRequest('POST', url);

    request.files.add(http.MultipartFile(
        'image', file.readAsBytes().asStream(), file.lengthSync(),
        filename: file.path));


    await request.send().then((response) async {
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        }).onData((data) {
          print("future $data");
          value1 = data;
          return data;
        });
      } else {
        value1 = "Error";
        return value1;
      }
    });
    return value1;
    //     url, body: {
    //   "image": file
    // });
    //
    // return response.body;
  }

  Future<String> setImageVendor(File file) async {

    print('its working $file');

    var url = Uri.parse("https://thehomelyy.com/vendor-post.php");

    String value1 = "";

    var request = http.MultipartRequest('POST', url);

    request.files.add(http.MultipartFile(
        'image', file.readAsBytes().asStream(), file.lengthSync(),
        filename: file.path));


    await request.send().then((response) async {
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        }).onData((data) {
          print("future $data");
          value1 = data;
          return data;
        });
      } else {
        value1 = "Error";
        return value1;
      }
    });
    return value1;
    //     url, body: {
    //   "image": file
    // });
    //
    // return response.body;
  }


  Future<String> setImageProduct(File file) async {
    var url = Uri.parse("https://thehomelyy.com/product-post.php");

    String value1 = "";

    var request = http.MultipartRequest('POST', url);

    request.files.add(http.MultipartFile(
        'image', file.readAsBytes().asStream(), file.lengthSync(),
        filename: file.path));

    await request.send().then((response) async {
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        }).onData((data) {
          print("future $data");

          value1 = data;
        });
        return value1;
      } else {
        value1 = "Error";
        return value1;
      }
    });
    return value1;
    //     url, body: {
    //   "image": file
    // });
    //
    // return response.body;
  }

  Future<List<ProductMainModel>> getProductMain({
    @required String vendorId,
  }) async {
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/productsvendorget?vendorid=$vendorId");
    var response = await http.get(url);
    print('gotres ${response.body}');

    if (response.body != "[]") {
      print('gotinner ');
      List productList = json.decode(response.body);
      Iterable<ProductMainModel> products = productList.map((e) {
        return ProductMainModel().fromJson(e);
      });

      return products.toList();

    } else {
      return [];
    }
  }
}
