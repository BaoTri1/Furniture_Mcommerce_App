class ListDistrict {
  late List<District> results;

  ListDistrict({required this.results});

  ListDistrict.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <District>[];
      json['results'].forEach((v) {
        results.add(new District.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class District {
  late String districtId;
  late String districtName;
  late String districtType;
  late String provinceId;

  District(
      {required this.districtId,
      required this.districtName,
      required this.districtType,
      required this.provinceId});

  District.fromJson(Map<String, dynamic> json) {
    districtId = json['district_id'];
    districtName = json['district_name'];
    districtType = json['district_type'];
    provinceId = json['province_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    data['district_type'] = this.districtType;
    data['province_id'] = this.provinceId;
    return data;
  }
}
