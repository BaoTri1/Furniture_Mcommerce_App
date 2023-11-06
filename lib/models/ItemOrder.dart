class ItemOrder {
  String? idProduct;
  int? numProduct;

  ItemOrder({this.idProduct, this.numProduct});

  ItemOrder.fromJson(Map<String, dynamic> json) {
    idProduct = json['idProduct'];
    numProduct = json['numProduct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idProduct'] = this.idProduct;
    data['numProduct'] = this.numProduct;
    return data;
  }
}