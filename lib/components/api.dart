import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AllApi {
  Future<List<OrderTotalModel>> getOrderTotal() async {
    var getOrderTotalUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getOrderTotalVendor");
    var response = await http.get(getOrderTotalUrl);
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
      {@required String status}) async {
    var getOrderStatusUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getOrderStatusVendor?status=$status");
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
    @required String productVarient,
    @required String varientId,
    @required String cutPrice,
    @required String requestDate,
  }) async {
    var addProductUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/addProductVendor");
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
        "status": "stock_status_pending",
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
    var addProductUrl = Uri.parse("");
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
        "status": "stock_status_pending",
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

  Future<VendorModel> getVendor({@required String email}) async {
    var getVendorUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getVendor?email=$email");
    var response = await http.get(getVendorUrl);
    if (response.body != "null") {
      Map<String, dynamic> vendor = json.decode(response.body);
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
      return null;
    }
  }

  Future<List<ProductModel>> getProducts({
    @required String vendorId,
    @required String categoryId,
    @required String verify,
  }) async {
    var getProductsUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getProductsVendor?vendorId=$vendorId&categoryId=$categoryId&verify=$verify");
    var response = await http.get(getProductsUrl);
    if (response.body != "null") {
      List productList = json.decode(response.body);
      Iterable<ProductModel> products = productList.map((e) {
        return ProductModel().fromJson(e);
      });
      return products.toList();
    } else {
      return null;
    }
  }

  Future<List<ProductModel>> getProductsVarient({
    @required String varientId,
    @required String verify,
  }) async {
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/varientProductGet?varientid=$varientId&verify=$verify");
    var response = await http.get(url);
    var body = json.decode(response.body);
    if (body != "[]") {
      List productList = json.decode(response.body);
      Iterable<ProductModel> products = productList.map((e) {
        return ProductModel().fromJson(e);
      });
      return products.toList();
    } else {
      return null;
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
      'type': type,
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

  Future<List<CuisineModel>> getCuisine() async {
    var getCuisineUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getCuisines");
    var response = await http.get(getCuisineUrl);
    if (response.body != "null") {
      List cuisineList = json.decode(response.body);
      Iterable<CuisineModel> cuisine = cuisineList.map((e) {
        return CuisineModel().fromJson(e);
      });
      return cuisine.toList();
    } else {
      return null;
    }
  }

  Future<List<CategoryModel>> getAllCategories() async {
    var getCategoryUrl = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/getAllCategories");
    var response = await http.get(getCategoryUrl);
    if (response.body != "null") {
      List categoryList = json.decode(response.body);
      Iterable<CategoryModel> category = categoryList.map((e) {
        return CategoryModel().fromJson(e);
      });
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
  }) async {
    var date = DateFormat('dd-MM-yyyy').format(
      DateTime.now().subtract(
        const Duration(days: 30),
      ),
    );
    var lastDigits = phoneNumber.substring(6);
    var url = Uri.parse(
        "https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-0-aveoz/service/Homelyy/incoming_webhook/newVendor");
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
      'rating': 'pending',
      'cuisine': '[cuisine]',
      'category': '[category]',
      'verify': '0',
      'status': 'false',
      'last_payment_date': date,
    });
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
    }
  }

  Future<void> putLocation(String vendorId) async {
    // LocationData locationData = await Location().getLocation();
    var lat = 19.0760; //locationData.latitude;
    var lon = 72.8777; //locationData.longitude;
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
    if (response.body != "[]") {
      List productList = json.decode(response.body);
      Iterable<ProductMainModel> products = productList.map((e) {
        return ProductMainModel().fromJson(e);
      });
      return products.toList();
    } else {
      return null;
    }
  }
}
