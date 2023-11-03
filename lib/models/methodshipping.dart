class FetchMethodShipping {
  int? errCode;
  String? errMessage;
  List<Methodshinpping>? methodshinppings;

  FetchMethodShipping({this.errCode, this.errMessage, this.methodshinppings});

  FetchMethodShipping.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    if (json['methodshinppings'] != null) {
      methodshinppings = <Methodshinpping>[];
      json['methodshinppings'].forEach((v) {
        methodshinppings!.add(new Methodshinpping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    if (this.methodshinppings != null) {
      data['methodshinppings'] =
          this.methodshinppings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Methodshinpping {
  String? idShipment;
  String? nameShipment;
  int? fee;
  String? timeShip;
  String? iconShipment;

  Methodshinpping(
      {this.idShipment,
        this.nameShipment,
        this.fee,
        this.timeShip,
        this.iconShipment});

  Methodshinpping.fromJson(Map<String, dynamic> json) {
    idShipment = json['idShipment'];
    nameShipment = json['nameShipment'];
    fee = json['fee'];
    timeShip = json['timeShip'];
    iconShipment = json['iconShipment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idShipment'] = this.idShipment;
    data['nameShipment'] = this.nameShipment;
    data['fee'] = this.fee;
    data['timeShip'] = this.timeShip;
    data['iconShipment'] = this.iconShipment;
    return data;
  }
}