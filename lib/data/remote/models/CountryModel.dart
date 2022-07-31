class CountryModel {
  List<CountryData> data;
  bool success = false;
  CountryModel({this.data});

  CountryModel.fromJson(Map<String, dynamic> json) {


    if (json['data'] != null) {
      success = true;
      data = new List<CountryData>();
      json['data'].forEach((v) {
        data.add(new CountryData.fromJson(v));
      });
    } else {
      success = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryData {
  int id;
  String name;

  CountryData({this.id, this.name});

  CountryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}