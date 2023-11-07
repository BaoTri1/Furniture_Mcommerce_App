class FetchListCategory {
  int? errCode;
  String? errMessage;
  List<Category>? categorys;

  FetchListCategory({this.errCode, this.errMessage, this.categorys});

  FetchListCategory.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    if (json['categorys'] != null) {
      categorys = <Category>[];
      json['categorys'].forEach((v) {
        categorys!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    if (this.categorys != null) {
      data['categorys'] = this.categorys!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? idCat;
  String? nameCat;

  Category({this.idCat, this.nameCat});

  Category.fromJson(Map<String, dynamic> json) {
    idCat = json['idCat'];
    nameCat = json['nameCat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCat'] = this.idCat;
    data['nameCat'] = this.nameCat;
    return data;
  }
}