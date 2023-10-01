class ListProvince {
  late List<Province> results;

  ListProvince({required this.results});

  ListProvince.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Province>[];
      json['results'].forEach((v) {
        results.add(new Province.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class Province {
  late String provinceId;
  late String provinceName;
  late String provinceType;

  Province(
      {required this.provinceId,
      required this.provinceName,
      required this.provinceType});

  Province.fromJson(Map<String, dynamic> json) {
    provinceId = json['province_id'];
    provinceName = json['province_name'];
    provinceType = json['province_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['province_id'] = this.provinceId;
    data['province_name'] = this.provinceName;
    data['province_type'] = this.provinceType;
    return data;
  }
}
