class Account {
  int id;
  String idUser;
  String sdt;
  String passwd;
  int isLogin;
  String token;

  Account(
      {required this.id,
        required this.idUser,
        required this.sdt,
        required this.passwd,
        required this.isLogin,
        required this.token});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'idUser': idUser,
      'sdt': sdt,
      'passwd': passwd,
      'isLogin': isLogin,
      'token': token,
    };
    return map;
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      idUser: map['idUser'],
      sdt: map['sdt'],
      passwd: map['passwd'],
      isLogin: map['isLogin'],
      token: map['token'],
    );
  }
}
