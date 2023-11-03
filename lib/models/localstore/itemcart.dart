class ItemCart {
  int id;
  String idUser;
  String idProduct;
  String category;
  String name;
  double price;
  int quantity;
  String urlImg;

  ItemCart(
      {required this.id,
        required this.idUser,
        required this.idProduct,
        required this.category,
        required this.name,
        required this.price,
        required this.quantity,
        required this.urlImg});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'idUser': idUser,
      'idProduct': idProduct,
      'category': category,
      'name': name,
      'price': price,
      'quantity': quantity,
      'urlImg': urlImg
    };
    return map;
  }

  factory ItemCart.fromMap(Map<String, dynamic> map) {
    return ItemCart(
        id: map['id'],
        idUser: map['idUser'],
        idProduct: map['idProduct'],
        category: map['category'],
        name: map['name'],
        price: map['price'],
        quantity: map['quantity'],
        urlImg: map['urlImg']);
  }
}
