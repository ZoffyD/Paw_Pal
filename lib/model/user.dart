class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? RegDate;

  User(
    { this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.RegDate,});

    User.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
      email = json['email'];
      password = json['password'];
      phone = json['phone'];
      RegDate = json['RegDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['RegDate'] = RegDate;
    return data;
  }
}