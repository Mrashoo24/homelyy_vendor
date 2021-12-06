// ignore_for_file: unnecessary_new, prefer_collection_literals

class OrderTotalModel {
  String discount;
  String name;
  String phone;
  String subtotal;
  String date;
  String status;
  String vid;
  String total;
  String savings;
  String address;
  String ref;
  String orderId;
  String paymentMethod;

  OrderTotalModel({
    this.discount,
    this.name,
    this.phone,
    this.subtotal,
    this.date,
    this.status,
    this.vid,
    this.total,
    this.savings,
    this.address,
    this.ref,
    this.orderId,
    this.paymentMethod,
  });

  fromJson(Map<String, dynamic> json) {
    return OrderTotalModel(
      discount: json['discount'],
      name: json['name'],
      phone: json['phone'],
      subtotal: json['subtotal'],
      date: json['date'],
      status: json['status'],
      vid: json['vid'],
      total: json['total'],
      savings: json['savings'],
      address: json['address'],
      ref: json['ref'],
      orderId: json['order_id'],
      paymentMethod: json['payment_method'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount'] = discount;
    data['name'] = name;
    data['phone'] = phone;
    data['subtotal'] = subtotal;
    data['date'] = date;
    data['status'] = status;
    data['vid'] = vid;
    data['total'] = total;
    data['savings'] = savings;
    data['address'] = address;
    data['ref'] = ref;
    data['order_id'] = orderId;
    data['payment_method'] = paymentMethod;
    return data;
  }
}

class OrderModel {
  String img;
  String price;
  String title;
  String recipe;
  String quantity;
  String requirement;
  String itemnumber;
  String cutprice;
  String ogprice;
  String ogcutprice;
  String discount;
  String shop;
  String ref;
  String date;
  String time;
  String vendorid;
  String foodid;
  String orderId;

  OrderModel({
    this.img,
    this.price,
    this.title,
    this.recipe,
    this.quantity,
    this.requirement,
    this.itemnumber,
    this.cutprice,
    this.ogprice,
    this.ogcutprice,
    this.discount,
    this.shop,
    this.date,
    this.time,
    this.ref,
    this.vendorid,
    this.foodid,
    this.orderId,
  });

  fromJson(Map<String, dynamic> json) {
    return OrderModel(
      img: json['img'],
      price: json['price'],
      title: json['title'],
      recipe: json['recipe'],
      quantity: json['quantity'],
      requirement: json['requirement'],
      itemnumber: json['itemnumber'],
      cutprice: json['cutprice'],
      ogprice: json['ogprice'],
      ogcutprice: json['ogcutprice'],
      discount: json['discount'],
      shop: json['shop'],
      date: json['date'],
      time: json['time'],
      ref: json['ref'],
      vendorid: json['vendorid'],
      foodid: json["foodid"],
      orderId: json['order_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['img'] = img;
    data['price'] = price;
    data['title'] = title;
    data['recipe'] = recipe;
    data['quantity'] = quantity;
    data['requirement'] = requirement;
    data['itemnumber'] = itemnumber;
    data['cutprice'] = cutprice;
    data['ogprice'] = ogprice;
    data['ogcutprice'] = ogcutprice;
    data['discount'] = discount;
    data['shop'] = shop;
    data['date'] = date;
    data['time'] = time;
    data['ref'] = ref;
    data['vendorid'] = vendorid;
    data["foodid"] = foodid;
    data['order_id'] = orderId;
    return data;
  }
}
