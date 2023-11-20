class FetchOrder {
  int? errCode;
  String? errMessage;
  Order? orders;

  FetchOrder({this.errCode, this.errMessage, this.orders});

  FetchOrder.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    orders =
    json['orders'] != null ? new Order.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    if (this.orders != null) {
      data['orders'] = this.orders!.toJson();
    }
    return data;
  }
}

class FetchListOrder {
  int? errCode;
  String? errMessage;
  List<Order>? orders;

  FetchListOrder({this.errCode, this.errMessage, this.orders});

  FetchListOrder.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FetchNumOrder {
  int? errCode;
  String? errMessage;
  int? numorder;

  FetchNumOrder({this.errCode, this.errMessage, this.numorder});

  FetchNumOrder.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    numorder = json['numorder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    data['numorder'] = this.numorder;
    return data;
  }
}

class Order {
  String? idOrder;
  String? nameCustomer;
  String? sDT;
  String? address;
  String? nameShipment;
  int? fee;
  String? namePayment;
  String? idStatus;
  String? name;
  String? quantity;
  int? total;
  int? statusPayment;
  String? dayCreateAt;
  String? dayUpdateAt;
  List<DetailOrder>? detailOrder;

  Order(
      {this.idOrder,
        this.nameCustomer,
        this.sDT,
        this.address,
        this.nameShipment,
        this.fee,
        this.namePayment,
        this.idStatus,
        this.name,
        this.total,
        this.statusPayment,
        this.dayCreateAt,
        this.dayUpdateAt,
        this.detailOrder});

  Order.fromJson(Map<String, dynamic> json) {
    idOrder = json['idOrder'];
    nameCustomer = json['NameCustomer'];
    sDT = json['SDT'];
    address = json['address'];
    nameShipment = json['nameShipment'];
    fee = json['fee'];
    namePayment = json['namePayment'];
    idStatus = json['idStatus'];
    name = json['name'];
    quantity = json['Quantity'];
    total = json['total'];
    statusPayment = json['StatusPayment'];
    dayCreateAt = json['dayCreateAt'];
    dayUpdateAt = json['dayUpdateAt'];
    if (json['DetailOrder'] != null) {
      detailOrder = <DetailOrder>[];
      json['DetailOrder'].forEach((v) {
        detailOrder!.add(new DetailOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idOrder'] = this.idOrder;
    data['NameCustomer'] = this.nameCustomer;
    data['SDT'] = this.sDT;
    data['address'] = this.address;
    data['nameShipment'] = this.nameShipment;
    data['fee'] = this.fee;
    data['namePayment'] = this.namePayment;
    data['idStatus'] = this.idStatus;
    data['name'] = this.name;
    data['Quantity'] = this.quantity;
    data['total'] = this.total;
    data['StatusPayment'] = this.statusPayment;
    data['dayCreateAt'] = this.dayCreateAt;
    data['dayUpdateAt'] = this.dayUpdateAt;
    if (this.detailOrder != null) {
      data['DetailOrder'] = this.detailOrder!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class DetailOrder {
  String? idProduct;
  String? nameProduct;
  String? imgUrl;
  int? originalPrice;
  int? finalPrice;
  int? numProduct;

  DetailOrder(
      {this.idProduct,
        this.nameProduct,
        this.imgUrl,
        this.originalPrice,
        this.finalPrice,
        this.numProduct});

  DetailOrder.fromJson(Map<String, dynamic> json) {
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    imgUrl = json['imgUrl'];
    originalPrice = json['originalPrice'];
    finalPrice = json['finalPrice'];
    numProduct = json['numProduct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idProduct'] = this.idProduct;
    data['nameProduct'] = this.nameProduct;
    data['imgUrl'] = this.imgUrl;
    data['originalPrice'] = this.originalPrice;
    data['finalPrice'] = this.finalPrice;
    data['numProduct'] = this.numProduct;
    return data;
  }
}