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

class Order {
  String? idOrder;
  String? nameCustomer;
  String? sDT;
  String? address;
  String? name;
  int? total;
  int? statusPayment;
  String? dayCreateAt;
  List<DetailOrder>? detailOrder;

  Order(
      {this.idOrder,
        this.nameCustomer,
        this.sDT,
        this.address,
        this.name,
        this.total,
        this.statusPayment,
        this.dayCreateAt,
        this.detailOrder});

  Order.fromJson(Map<String, dynamic> json) {
    idOrder = json['idOrder'];
    nameCustomer = json['NameCustomer'];
    sDT = json['SDT'];
    address = json['address'];
    name = json['name'];
    total = json['total'];
    statusPayment = json['StatusPayment'];
    dayCreateAt = json['dayCreateAt'];
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
    data['name'] = this.name;
    data['total'] = this.total;
    data['StatusPayment'] = this.statusPayment;
    data['dayCreateAt'] = this.dayCreateAt;
    if (this.detailOrder != null) {
      data['DetailOrder'] = this.detailOrder!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailOrder {
  String? idProduct;
  String? nameProduct;
  int? originalPrice;
  int? finalPrice;
  int? numProduct;

  DetailOrder(
      {this.idProduct,
        this.nameProduct,
        this.originalPrice,
        this.finalPrice,
        this.numProduct});

  DetailOrder.fromJson(Map<String, dynamic> json) {
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    originalPrice = json['originalPrice'];
    finalPrice = json['finalPrice'];
    numProduct = json['numProduct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idProduct'] = this.idProduct;
    data['nameProduct'] = this.nameProduct;
    data['originalPrice'] = this.originalPrice;
    data['finalPrice'] = this.finalPrice;
    data['numProduct'] = this.numProduct;
    return data;
  }
}