class LoginModel {
  String accessToken;
  String tokenType;
  String expiresAt;
  String message;
  int code;
  UserData user;
  bool success = false;

  LoginModel(
      {this.accessToken,
      this.tokenType,
      this.expiresAt,
      this.user,
      this.message,
      this.code,
      this.success});

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    code = json['code'];

    if (json.containsKey("access_token")) {
      success = true;
      accessToken = json['access_token'];
    }
    if (json.containsKey("token_type")) {
      success = true;
      tokenType = json['token_type'];
    }
    if (json.containsKey("expires_at")) {
      success = true;
      expiresAt = json['expires_at'];
    }

    if (json.containsKey("user")) {
      success = true;
      user = json['user'] != null ? new UserData.fromJson(json['user']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_at'] = this.expiresAt;
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class UserData {
  int id;
  String type;
  String name;
  String email;
  String avatar;
  String avatarOriginal;
  String address;
  String country;
  String city;
  String postalCode;
  String phone;

  UserData(
      {this.id,
      this.type,
      this.name,
      this.email,
      this.avatar,
      this.avatarOriginal,
      this.address,
      this.country,
      this.city,
      this.postalCode,
      this.phone});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    avatarOriginal = json['avatar_original'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    postalCode = json['postal_code'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['avatar_original'] = this.avatarOriginal;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['phone'] = this.phone;
    return data;
  }
}
