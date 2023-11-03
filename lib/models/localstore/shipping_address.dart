class ShippingAddress {
  late int id;
  late String idUser;
  late String name;
  late String sdt;
  late String address;
  late int isDefault;

  ShippingAddress(
      {required this.id,
      required this.idUser,
      required this.name,
      required this.sdt,
      required this.address,
      required this.isDefault});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'idUser': idUser,
      'name': name,
      'sdt': sdt,
      'address': address,
      'isDefault': isDefault
    };
    return map;
  }

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
        id: map['id'],
        idUser: map['idUser'],
        name: map['name'],
        sdt: map['sdt'],
        address: map['address'],
        isDefault: map['isDefault']);
  }
}
