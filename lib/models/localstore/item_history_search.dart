class ItemHistorySearch {
  int id;
  String idUser;
  String text;

  ItemHistorySearch(
      {required this.id, required this.idUser, required this.text});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'idUser': idUser, 'text': text};
    return map;
  }

  factory ItemHistorySearch.fromMap(Map<String, dynamic> map) {
    return ItemHistorySearch(
        id: map['id'], idUser: map['idUser'], text: map['text']);
  }
}
