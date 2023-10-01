class ItemHistorySearch {
  int id;
  String id_user;
  String text;

  ItemHistorySearch(
      {required this.id, required this.id_user, required this.text});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'id_user': id_user, 'text': text};
    return map;
  }

  factory ItemHistorySearch.fromMap(Map<String, dynamic> map) {
    return ItemHistorySearch(
        id: map['id'], id_user: map['id_user'], text: map['text']);
  }
}
