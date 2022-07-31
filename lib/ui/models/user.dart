

class User {
  String accessToken;
  String tokenType;
  String expiresAt;
  bool isLoggedIn = false;
  String id;
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

  User(
      {this.accessToken,
      this.tokenType,
      this.expiresAt,
      this.isLoggedIn,
      this.id,
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
}
