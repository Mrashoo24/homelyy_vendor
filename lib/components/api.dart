import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homelyvendor/components/model.dart';
import 'package:http/http.dart' as http;

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
}
