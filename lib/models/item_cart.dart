class ItemCart {
  int id;
  String id_user;
  String name;
  double price;
  int quantity;
  String urlImg;

  ItemCart(
      {required this.id,
      required this.id_user,
      required this.name,
      required this.price,
      required this.quantity,
      required this.urlImg});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'id_user': id_user,
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
        id_user: map['id_user'],
        name: map['name'],
        price: map['price'],
        quantity: map['quantity'],
        urlImg: map['urlImg']);
  }
}
