class Credit {
  int id;
  String idUser;
  String numberCredit;
  String name;
  String month;
  String year;

  Credit(
      {required this.id,
        required this.idUser,
        required this.numberCredit,
        required this.name,
        required this.month,
        required this.year});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'idUser': idUser,
      'numberCredit': numberCredit,
      'name': name,
      'month': month,
      'year': year,
    };
    return map;
  }

  factory Credit.fromMap(Map<String, dynamic> map) {
    return Credit(
      id: map['id'],
      idUser: map['idUser'],
      numberCredit: map['numberCredit'],
      name: map['name'],
      month: map['month'],
      year: map['year'],
    );
  }
}