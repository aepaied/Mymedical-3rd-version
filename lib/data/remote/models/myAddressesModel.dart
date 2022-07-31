class MyAddressesModel {
  List<MyAddressesData> data;
  bool success = false;
  MyAddressesModel({this.data});

  MyAddressesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      success = true;
      data = new List<MyAddressesData>();
      json['data'].forEach((v) {
        data.add(new MyAddressesData.fromJson(v));
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

class MyAddressesData {
  int id;
  bool select = false;
  String address;
  String postalCode;
  String phone;
  int country;
  int city;
  int province;
  int region;
  int setDefault;
  AddressCountry addressCountry;
  AddressCountry addressCity;
  AddressCountry addressProvince;
  AddressCountry addressRegion;

  MyAddressesData(
      {this.address,
      this.id,
      this.postalCode,
      this.phone,
      this.country,
      this.city,
      this.province,
      this.region,
      this.setDefault,
      this.addressCountry,
      this.addressCity,
      this.addressProvince,
      this.addressRegion,
      this.select});

  MyAddressesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    postalCode = json['postal_code'];
    phone = json['phone'];
    country = json['country'];
    city = json['city'];
    region = json['region'];
    region = json['province'];
    setDefault = json['set_default'];
    addressCountry = json['address_country'] != null
        ? new AddressCountry.fromJson(json['address_country'])
        : null;
    addressCity = json['address_city'] != null
        ? new AddressCountry.fromJson(json['address_city'])
        : null;
    addressRegion = json['address_region'] != null
        ? new AddressCountry.fromJson(json['address_region'])
        : null;
    addressProvince = json['address_province'] != null
        ? new AddressCountry.fromJson(json['address_province'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['postal_code'] = this.postalCode;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['city'] = this.city;
    data['region'] = this.region;
    data['set_default'] = this.setDefault;
    if (this.addressCountry != null) {
      data['address_country'] = this.addressCountry.toJson();
    }
    if (this.addressCity != null) {
      data['address_city'] = this.addressCity.toJson();
    }
    if (this.addressRegion != null) {
      data['address_region'] = this.addressRegion.toJson();
    }
    return data;
  }
}

class AddressCountry {
  int id;
  String name;

  AddressCountry({this.id, this.name});

  AddressCountry.fromJson(Map<String, dynamic> json) {
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
