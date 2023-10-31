class ItemFavorite {
  String id;
  String idUser;
  String idProduct;
  String name;
  double price;
  String urlImg;

  ItemFavorite(
      {required this.id,
        required this.idUser,
        required this.idProduct,
        required this.name,
        required this.price,
        required this.urlImg});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'idUser': idUser,
      'idProduct' :idProduct,
      'name': name,
      'price': price,
      'urlImg': urlImg
    };
    return map;
  }

  factory ItemFavorite.fromMap(Map<String, dynamic> map) {
    return ItemFavorite(
        id: map['id'],
        idUser: map['idUser'],
        idProduct: map['idProduct'],
        name: map['name'],
        price: map['price'],
        urlImg: map['urlImg']);
  }
}
