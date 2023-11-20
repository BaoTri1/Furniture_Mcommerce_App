class FetchListReview {
  int? errCode;
  String? errMessage;
  int? totalRow;
  String? limit;
  String? page;
  int? totalPage;
  List<Review>? reviews;

  FetchListReview(
      {this.errCode,
        this.errMessage,
        this.totalRow,
        this.limit,
        this.page,
        this.totalPage,
        this.reviews});

  FetchListReview.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    totalRow = json['total_row'];
    limit = json['limit'];
    page = json['page'];
    totalPage = json['total_page'];
    if (json['reviews'] != null) {
      reviews = <Review>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    data['total_row'] = this.totalRow;
    data['limit'] = this.limit;
    data['page'] = this.page;
    data['total_page'] = this.totalPage;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Review {
  String? idRat;
  String? idUser;
  String? avatar;
  String? fullName;
  int? point;
  String? comment;
  String? timeCreate;

  Review(
      {this.idRat,
        this.idUser,
        this.avatar,
        this.fullName,
        this.point,
        this.comment,
        this.timeCreate});

  Review.fromJson(Map<String, dynamic> json) {
    idRat = json['idRat'];
    idUser = json['idUser'];
    avatar = json['avatar'];
    fullName = json['fullName'];
    point = json['point'];
    comment = json['comment'];
    timeCreate = json['timeCreate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idRat'] = this.idRat;
    data['idUser'] = this.idUser;
    data['avatar'] = this.avatar;
    data['fullName'] = this.fullName;
    data['point'] = this.point;
    data['comment'] = this.comment;
    data['timeCreate'] = this.timeCreate;
    return data;
  }
}

class FetchRating {
  int? errCode;
  String? errMessage;
  Ratings? ratings;

  FetchRating({this.errCode, this.errMessage, this.ratings});

  FetchRating.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMessage = json['errMessage'];
    ratings =
    json['ratings'] != null ? new Ratings.fromJson(json['ratings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    if (this.ratings != null) {
      data['ratings'] = this.ratings!.toJson();
    }
    return data;
  }
}

class Ratings {
  String? nameProduct;
  String? aVGPoint;
  int? numReviews;

  Ratings({this.nameProduct, this.aVGPoint, this.numReviews});

  Ratings.fromJson(Map<String, dynamic> json) {
    nameProduct = json['nameProduct'];
    aVGPoint = json['AVGPoint'];
    numReviews = json['NumReviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameProduct'] = this.nameProduct;
    data['AVGPoint'] = this.aVGPoint;
    data['NumReviews'] = this.numReviews;
    return data;
  }
}