class ItemFavorite {
  String id;
  String id_user;
  String name;
  String urlImg;

  ItemFavorite(
      {required this.id,
      required this.id_user,
      required this.name,
      required this.urlImg});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'id_user': id_user,
      'name': name,
      'urlImg': urlImg
    };
    return map;
  }

  factory ItemFavorite.fromMap(Map<String, dynamic> map) {
    return ItemFavorite(
        id: map['id'],
        id_user: map['id_user'],
        name: map['name'],
        urlImg: map['urlImg']);
  }
}
