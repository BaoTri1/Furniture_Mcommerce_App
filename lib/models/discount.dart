class FetchListDiscount {
  int? errCode;
  String? errMessage;
  int? totalRow;
  String? limit;
  String? page;
  int? totalPage;
  List<Discount>? discounts;

  FetchListDiscount(
      {this.errCode,
        this.errMessage,
        this.totalRow,
        this.limit,
        this.page,
        this.totalPage,
        this.discounts});

  FetchListDiscount.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    totalRow = json['total_row'];
    limit = json['limit'];
    page = json['page'];
    totalPage = json['total_page'];
    if (json['discounts'] != null) {
      discounts = <Discount>[];
      json['discounts'].forEach((v) {
        discounts!.add(new Discount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    data['total_row'] = this.totalRow;
    data['limit'] = this.limit;
    data['page'] = this.page;
    data['total_page'] = this.totalPage;
    if (this.discounts != null) {
      data['discounts'] = this.discounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FetchCheckDiscountValid {
  int? errCode;
  String? errMessage;
  List<Discount>? discounts;

  FetchCheckDiscountValid({this.errCode, this.errMessage, this.discounts});

  FetchCheckDiscountValid.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    if (json['discounts'] != null) {
      discounts = <Discount>[];
      json['discounts'].forEach((v) {
        discounts!.add(new Discount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    if (this.discounts != null) {
      data['discounts'] = this.discounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Discount {
  String? idDiscount;
  String? nameDiscount;
  String? nameProduct;
  String? idProduct;
  int? value;
  int? numDiscount;
  String? dayStart;
  String? dayEnd;

  Discount(
      {this.idDiscount,
        this.nameDiscount,
        this.nameProduct,
        this.idProduct,
        this.value,
        this.numDiscount,
        this.dayStart,
        this.dayEnd});

  Discount.fromJson(Map<String, dynamic> json) {
    idDiscount = json['idDiscount'];
    nameDiscount = json['nameDiscount'];
    nameProduct = json['nameProduct'];
    idProduct = json['idProduct'];
    value = json['value'];
    numDiscount = json['numDiscount'];
    dayStart = json['dayStart'];
    dayEnd = json['dayEnd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idDiscount'] = this.idDiscount;
    data['nameDiscount'] = this.nameDiscount;
    data['nameProduct'] = this.nameProduct;
    data['idProduct'] = this.idProduct;
    data['value'] = this.value;
    data['numDiscount'] = this.numDiscount;
    data['dayStart'] = this.dayStart;
    data['dayEnd'] = this.dayEnd;
    return data;
  }
}