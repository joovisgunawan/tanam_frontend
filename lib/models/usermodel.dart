class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? gender;
  int? phone;
  String? address;
  String? photo;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.gender,
    this.phone,
    this.address,
    this.photo,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['user_id'];
    name = json['user_name'];
    email = json['user_email'];
    password = json['user_password'];
    gender = json['user_gender'];
    phone = json['user_phone'];
    address = json['user_address'];
    photo = json['user_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = id;
    data['user_name'] = name;
    data['user_email'] = email;
    data['user_password'] = password;
    data['user_gender'] = gender;
    data['user_phone'] = phone;
    data['user_address'] = address;
    data['user_photo'] = photo;
    return data;
  }

}

List userList = [
  UserModel(
    id: '1',
    name: 'user',
    email: 'user@gmail.com',
    password: 'user1234',
    gender: 'male',
    phone: 123456789,
    address: 'unknown',
    photo: 'assets/images/logo.png',
  ),
  UserModel(
    id: '2',
    name: 'admin',
    email: 'admin@gmail.com',
    password: 'admin1234',
    gender: 'male',
    phone: 123456789,
    address: 'unknown',
    photo: 'assets/images/logo.png',
  ),
];
