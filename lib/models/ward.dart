class ListWard {
  late List<Ward> results;

  ListWard({required this.results});

  ListWard.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Ward>[];
      json['results'].forEach((v) {
        results.add(new Ward.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class Ward {
  late String districtId;
  late String wardId;
  late String wardName;
  late String wardType;

  Ward(
      {required this.districtId,
      required this.wardId,
      required this.wardName,
      required this.wardType});

  Ward.fromJson(Map<String, dynamic> json) {
    districtId = json['district_id'];
    wardId = json['ward_id'];
    wardName = json['ward_name'];
    wardType = json['ward_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['district_id'] = this.districtId;
    data['ward_id'] = this.wardId;
    data['ward_name'] = this.wardName;
    data['ward_type'] = this.wardType;
    return data;
  }
}
