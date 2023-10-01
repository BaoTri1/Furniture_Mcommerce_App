class ShippingAddress {
  late int id;
  late String id_user;
  late String name;
  late String sdt;
  late String address;
  late bool isDefault;

  ShippingAddress(
      {required this.id,
      required this.id_user,
      required this.name,
      required this.sdt,
      required this.address,
      required this.isDefault});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'id_user': id_user,
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
        id_user: map['id_user'],
        name: map['name'],
        sdt: map['sdt'],
        address: map['address'],
        isDefault: map['isDefault']);
  }
}
