class Authorization {
  int? errCode;
  String? errMessage;
  int? isAdmin;
  User? user;
  String? accessToken;

  Authorization(
      {this.errCode,
        this.errMessage,
        this.isAdmin,
        this.user,
        this.accessToken});

  Authorization.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    isAdmin = json['isAdmin'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    data['isAdmin'] = this.isAdmin;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['access_token'] = this.accessToken;
    return data;
  }
}

class User {
  String? idUser;
  String? idAcc;
  String? fullName;
  String? sdtUser;
  String? email;
  String? gender;
  String? dateOfBirth;
  String? avatar;

  User(
      {this.idUser,
        this.idAcc,
        this.fullName,
        this.sdtUser,
        this.email,
        this.gender,
        this.dateOfBirth,
        this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    idAcc = json['idAcc'];
    fullName = json['fullName'];
    sdtUser = json['sdtUser'];
    email = json['email'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUser'] = this.idUser;
    data['idAcc'] = this.idAcc;
    data['fullName'] = this.fullName;
    data['sdtUser'] = this.sdtUser;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['avatar'] = this.avatar;
    return data;
  }
}