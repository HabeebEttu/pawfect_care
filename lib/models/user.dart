// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pawfect_care/models/profile.dart';

class User {
  final String email;
  final String name;
  final String password;
  final String phone;
  final Profile profile;
  
  User({
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
    required this.profile
  });

  User copyWith({
    String? email,
    String? name,
    String? password,
    String? phone,
    Profile? profile,
  }) {
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'password': password,
      'phone': phone,
      'profile': profile.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      name: map['name'] as String,
      password: map['password'] as String,
      phone: map['phone'] as String,
      profile: Profile.fromMap(map['profile'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(email: $email, name: $name, password: $password, phone: $phone, profile: $profile)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.name == name &&
      other.password == password &&
      other.phone == phone &&
      other.profile == profile;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      name.hashCode ^
      password.hashCode ^
      phone.hashCode ^
      profile.hashCode;
  }
}
