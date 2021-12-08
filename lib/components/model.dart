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

class VendorModel {
  String type,
      email,
      image,
      address,
      description,
      vendorId,
      user,
      password,
      inPromotion,
      name,
      rating,
      verify;
  Map<String, dynamic> location;
  List cuisine, category;
  bool status;

  VendorModel({
    this.address,
    this.category,
    this.cuisine,
    this.description,
    this.email,
    this.image,
    this.inPromotion,
    this.location,
    this.name,
    this.password,
    this.rating,
    this.status,
    this.type,
    this.user,
    this.vendorId,
    this.verify,
  });

  fromJson(Map<String, dynamic> json) {
    return VendorModel(
      address: json['address'],
      category: json['category'],
      cuisine: json['cuisine'],
      description: json['description'],
      email: json['email'],
      image: json['image'],
      inPromotion: json['inPromotion'],
      location: json['location'],
      name: json['name'],
      password: json['password'],
      rating: json['rating'],
      status: json['status'],
      type: json['type'],
      user: json['user'],
      vendorId: json['vendorid'],
      verify: json['verify'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['address'] = address;
    data['category'] = category;
    data['cuisine'] = cuisine;
    data['description'] = description;
    data['email'] = email;
    data['image'] = image;
    data['inPromotion'] = inPromotion;
    data['location'] = location;
    data['name'] = name;
    data['password'] = password;
    data['rating'] = rating;
    data['status'] = status;
    data['type'] = type;
    data['user'] = user;
    data['vendorid'] = vendorId;
    data['verify'] = verify;

    return data;
  }
}

class CategoryModel {
  String name, image, type, catId, vendorId;
  CategoryModel({
    this.catId,
    this.image,
    this.name,
    this.type,
    this.vendorId,
  });
  fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      catId: json['catid'],
      image: json['image'],
      name: json['name'],
      type: json['type'],
      vendorId: json['vendorid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catid'] = catId;
    data['image'] = image;
    data['name'] = name;
    data['type'] = type;
    data['vendorid'] = vendorId;
    return data;
  }
}

class ProductModel {
  String category,
      subCategory,
      description,
      vendorId,
      productId,
      name,
      image,
      price,
      varient,
      cutprice,
      varientId;
  bool status;

  ProductModel({
    this.category,
    this.cutprice,
    this.description,
    this.image,
    this.name,
    this.price,
    this.productId,
    this.status,
    this.subCategory,
    this.varient,
    this.varientId,
    this.vendorId,
  });

  fromJson(Map<String, dynamic> json) {
    return ProductModel(
      category: json['category'],
      cutprice: json['cutprice'],
      description: json['description'],
      image: json['image'],
      name: json['name'],
      price: json['price'],
      productId: json['productid'],
      status: json['status'],
      subCategory: json['subcategory'],
      varient: json['varient'],
      varientId: json['varientid'],
      vendorId: json['vendorid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = category;
    data['cutprice'] = cutprice;
    data['description'] = description;
    data['image'] = image;
    data['name'] = name;
    data['price'] = price;
    data['productid'] = productId;
    data['status'] = status;
    data['subcategory'] = subCategory;
    data['varient'] = varient;
    data['varientid'] = varientId;
    data['vendorid'] = vendorId;
    return data;
  }
}
