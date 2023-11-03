class FetchMethodPayment {
  int? errCode;
  String? errMessage;
  List<Methodpayment>? methodpayments;

  FetchMethodPayment({this.errCode, this.errMessage, this.methodpayments});

  FetchMethodPayment.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    if (json['methodpayments'] != null) {
      methodpayments = <Methodpayment>[];
      json['methodpayments'].forEach((v) {
        methodpayments!.add(new Methodpayment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    if (this.methodpayments != null) {
      data['methodpayments'] =
          this.methodpayments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Methodpayment {
  String? idPayment;
  String? namePayment;
  String? iconPayment;

  Methodpayment({this.idPayment, this.namePayment, this.iconPayment});

  Methodpayment.fromJson(Map<String, dynamic> json) {
    idPayment = json['idPayment'];
    namePayment = json['namePayment'];
    iconPayment = json['iconPayment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idPayment'] = this.idPayment;
    data['namePayment'] = this.namePayment;
    data['iconPayment'] = this.iconPayment;
    return data;
  }
}