/*
class ProfileModel {
  UserData data;
  String message;
  Errors errors;

  ProfileModel({this.message,this.data, this.errors});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    if(json.containsKey("message")){
      message = json['message'];
    }
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;

    if(json.containsKey("errors")){
      errors =
      json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
    } else{
      errors = null;
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    if (this.errors != null) {
      data['errors'] = this.errors.toJson();
    }
    return data;
  }
}

class Errors {
  List<String> name;

  Errors({this.name});

  Errors.fromJson(Map<String, dynamic> json) {
    name = json['name'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class UserData {
  int id;
  String referredBy;
  String providerId;
  String userType;
  String name;
  String email;
  String emailVerifiedAt;
  String verificationCode;
  String newEmailVerificiationCode;
  String avatar;
  String avatarOriginal;
  String address;
  String country;
  String city;
  String passwordCode;
  String postalCode;
  String phone;
  int balance;
  int banned;
  String referralCode;
  String customerPackageId;
  int remainingUploads;
  String createdAt;
  String updatedAt;

  UserData(
      {this.id,
        this.referredBy,
        this.providerId,
        this.userType,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.verificationCode,
        this.newEmailVerificiationCode,
        this.avatar,
        this.avatarOriginal,
        this.address,
        this.country,
        this.city,
        this.passwordCode,
        this.postalCode,
        this.phone,
        this.balance,
        this.banned,
        this.referralCode,
        this.customerPackageId,
        this.remainingUploads,
        this.createdAt,
        this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referredBy = json['referred_by'];
    providerId = json['provider_id'];
    userType = json['user_type'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    verificationCode = json['verification_code'];
    newEmailVerificiationCode = json['new_email_verificiation_code'];
    avatar = json['avatar'];
    avatarOriginal = json['avatar_original'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    passwordCode = json['password_code'];
    postalCode = json['postal_code'];
    phone = json['phone'];
    balance = json['balance'];
    banned = json['banned'];
    referralCode = json['referral_code'];
    customerPackageId = json['customer_package_id'];
    remainingUploads = json['remaining_uploads'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['referred_by'] = this.referredBy;
    data['provider_id'] = this.providerId;
    data['user_type'] = this.userType;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['verification_code'] = this.verificationCode;
    data['new_email_verificiation_code'] = this.newEmailVerificiationCode;
    data['avatar'] = this.avatar;
    data['avatar_original'] = this.avatarOriginal;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['password_code'] = this.passwordCode;
    data['postal_code'] = this.postalCode;
    data['phone'] = this.phone;
    data['balance'] = this.balance;
    data['banned'] = this.banned;
    data['referral_code'] = this.referralCode;
    data['customer_package_id'] = this.customerPackageId;
    data['remaining_uploads'] = this.remainingUploads;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}*/

class ProfileModel {
  String message;
  UserData data;
  Errors errors;

  ProfileModel({this.message, this.data, this.errors});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('message')) {
      message = json['message'];
    }
    if (json.containsKey('data')) {
      data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    }

    if(json.containsKey("errors")){
      errors =
      json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Errors {
  List<String> name;

  Errors({this.name});

  Errors.fromJson(Map<String, dynamic> json) {
    name = json['name'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class UserData {
  int id;
  String referredBy;
  int providerId;
  String userType;
  String name;
  String email;
  String emailVerifiedAt;
  String verificationCode;
  String newEmailVerificiationCode;
  String avatar;
  String avatarOriginal;
  String address;
  String country;
  String city;
  String passwordCode;
  String postalCode;
  String phone;
  int balance;
  int banned;
  String referralCode;
  int customerPackageId;
  int remainingUploads;
  String deviceToken;
  String lang;
  String createdAt;
  String updatedAt;

  UserData(
      {this.id,
      this.referredBy,
      this.providerId,
      this.userType,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.verificationCode,
      this.newEmailVerificiationCode,
      this.avatar,
      this.avatarOriginal,
      this.address,
      this.country,
      this.city,
      this.passwordCode,
      this.postalCode,
      this.phone,
      this.balance,
      this.banned,
      this.referralCode,
      this.customerPackageId,
      this.remainingUploads,
      this.deviceToken,
      this.lang,
      this.createdAt,
      this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referredBy = json['referred_by'];
    providerId = json['provider_id'];
    userType = json['user_type'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    verificationCode = json['verification_code'];
    newEmailVerificiationCode = json['new_email_verificiation_code'];
    avatar = json['avatar'];
    avatarOriginal = json['avatar_original'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    passwordCode = json['password_code'];
    postalCode = json['postal_code'];
    phone = json['phone'];
    balance = json['balance'];
    banned = json['banned'];
    referralCode = json['referral_code'];
    customerPackageId = json['customer_package_id'];
    remainingUploads = json['remaining_uploads'];
    deviceToken = json['device_token'];
    lang = json['lang'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['referred_by'] = this.referredBy;
    data['provider_id'] = this.providerId;
    data['user_type'] = this.userType;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['verification_code'] = this.verificationCode;
    data['new_email_verificiation_code'] = this.newEmailVerificiationCode;
    data['avatar'] = this.avatar;
    data['avatar_original'] = this.avatarOriginal;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['password_code'] = this.passwordCode;
    data['postal_code'] = this.postalCode;
    data['phone'] = this.phone;
    data['balance'] = this.balance;
    data['banned'] = this.banned;
    data['referral_code'] = this.referralCode;
    data['customer_package_id'] = this.customerPackageId;
    data['remaining_uploads'] = this.remainingUploads;
    data['device_token'] = this.deviceToken;
    data['lang'] = this.lang;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
