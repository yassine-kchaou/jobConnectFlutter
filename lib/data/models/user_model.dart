import 'package:jobconnect/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? cinOrPassport;
  final String role;
  final String? avatar;
  final String? identityPic;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.cinOrPassport,
    required this.role,
    this.avatar,
    this.identityPic,
    this.createdAt,
    this.updatedAt,
  });

  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        phone: phoneNumber,
        address: address,
        city: city,
        country: country,
        postalCode: postalCode,
        cinOrPassport: cinOrPassport,
        role: role,
        avatar: avatar,
        identityPic: identityPic,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      postalCode: json['postalCode'],
      cinOrPassport: json['cinOrPassport'],
      role: json['type'] ?? json['role'] ?? 'employee',
      avatar: json['avatar'],
      identityPic: json['identityPic'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'cinOrPassport': cinOrPassport,
      'role': role,
      'avatar': avatar,
      'identityPic': identityPic,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class AuthResponseModel {
  final String token;
  final UserModel user;

  AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['access_token'] ?? json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': token, 'user': user.toJson()};
  }
}
