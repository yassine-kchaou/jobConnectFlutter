import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
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

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
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

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        address,
        city,
        country,
        postalCode,
        cinOrPassport,
        role,
        avatar,
        identityPic,
        createdAt,
        updatedAt,
      ];
}

class AuthResponse extends Equatable {
  final String token;
  final User user;

  const AuthResponse({required this.token, required this.user});

  @override
  List<Object> get props => [token, user];
}
