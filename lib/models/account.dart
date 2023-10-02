class Account {
  int id;
  String sdt;
  String passwd;
  int isLogin;

  Account(
      {required this.id,
        required this.sdt,
        required this.passwd,
        required this.isLogin});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'sdt': sdt,
      'passwd': passwd,
      'isLogin': isLogin
    };
    return map;
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      sdt: map['sdt'],
      passwd: map['passwd'],
      isLogin: map['isLogin'],
    );
  }
}
