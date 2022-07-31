class BusinessSettings {
  List<Details> details;
  bool success;
  int status;

  BusinessSettings({this.details, this.success, this.status});

  BusinessSettings.fromJson(Map<String, dynamic> json) {
    print(json);
    if (json['data'] != null) {
      details = <Details>[];
      json['data'].forEach((v) {
        details.add(Details.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (details != null) {
      data['data'] = details.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['status'] = status;
    return data;
  }
}

class Details {
  String type;
  dynamic value;

  Details({this.type, this.value});

  Details.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}
