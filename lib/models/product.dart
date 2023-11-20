class FetchProduct {
  int? errCode;
  String? errMessage;
  Product? product;

  FetchProduct({this.errCode, this.errMessage, this.product});

  FetchProduct.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}


class FetchListProduct {
  int? errCode;
  String? errMessage;
  int? totalRow;
  String? limit;
  String? page;
  int? totalPage;
  List<Product>? products;

  FetchListProduct(
      {this.errCode,
        this.errMessage,
        this.totalRow,
        this.limit,
        this.page,
        this.totalPage,
        this.products});

  FetchListProduct.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    totalRow = json['total_row'];
    limit = json['limit'];
    page = json['page'];
    totalPage = json['total_page'];
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(new Product.fromJson(v));
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
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? idProduct;
  String? aVGPoint;
  String? imgUrl;
  String? nameDiscount;
  int? value;
  String? dayStart;
  String? dayEnd;
  String? idCat;
  String? nameCat;
  String? idRoom;
  String? nameRoom;
  String? nameProduct;
  int? price;
  int? quantity;
  String? material;
  String? size;
  String? description;
  List<ListImageDetail>? listImageDetail;

  Product(
      {this.idProduct,
        this.aVGPoint,
        this.imgUrl,
        this.nameDiscount,
        this.value,
        this.dayStart,
        this.dayEnd,
        this.idCat,
        this.nameCat,
        this.idRoom,
        this.nameRoom,
        this.nameProduct,
        this.price,
        this.quantity,
        this.material,
        this.size,
        this.description,
        this.listImageDetail});

  Product.fromJson(Map<String, dynamic> json) {
    idProduct = json['idProduct'];
    aVGPoint = json['aVGPoint'];
    imgUrl = json['imgUrl'];
    nameDiscount = json['nameDiscount'];
    value = json['value'];
    dayStart = json['dayStart'];
    dayEnd = json['dayEnd'];
    idCat = json['idCat'];
    nameCat = json['nameCat'];
    idRoom = json['idRoom'];
    nameRoom = json['nameRoom'];
    nameProduct = json['nameProduct'];
    price = json['price'];
    quantity = json['quantity'];
    material = json['material'];
    size = json['size'];
    description = json['description'];
    if (json['listImageDetail'] != null) {
      listImageDetail = <ListImageDetail>[];
      json['listImageDetail'].forEach((v) {
        listImageDetail!.add(new ListImageDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idProduct'] = this.idProduct;
    data['aVGPoint'] = this.aVGPoint;
    data['imgUrl'] = this.imgUrl;
    data['nameDiscount'] = this.nameDiscount;
    data['value'] = this.value;
    data['dayStart'] = this.dayStart;
    data['dayEnd'] = this.dayEnd;
    data['idCat'] = this.idCat;
    data['nameCat'] = this.nameCat;
    data['idRoom'] = this.idRoom;
    data['nameRoom'] = this.nameRoom;
    data['nameProduct'] = this.nameProduct;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['material'] = this.material;
    data['size'] = this.size;
    data['description'] = this.description;
    if (this.listImageDetail != null) {
      data['listImageDetail'] =
          this.listImageDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ListImageDetail {
  String? imgUrl;

  ListImageDetail({this.imgUrl});

  ListImageDetail.fromJson(Map<String, dynamic> json) {
    imgUrl = json['imgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgUrl'] = this.imgUrl;
    return data;
  }
}