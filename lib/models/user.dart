// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/models/profile.dart';

class User {
  final String email;
  final String name;
  final String password;
  final String? phone;
  final Profile profile;
  final String userId;
  

  User({
    required this.email,
    required this.name,
    required this.password,
    this.phone,
    required this.profile,
    required this.userId,
  });

  User copyWith({
    String? email,
    String? name,
    String? password,
    String? phone,
    Profile? profile,
    String? userId,
  }) {
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      profile: profile ?? this.profile,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'password': password,
      'phone': phone,
      'profile': profile.toMap(),
      'userId': userId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      name: map['name'] as String,
      password: map['password'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      profile: Profile.fromMap(map['profile'] as Map<String,dynamic>),
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(email: $email, name: $name, password: $password, phone: $phone, profile: $profile, userId: $userId)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.name == name &&
      other.password == password &&
      other.phone == phone &&
      other.profile == profile &&
      other.userId == userId;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      name.hashCode ^
      password.hashCode ^
      phone.hashCode ^
      profile.hashCode ^
      userId.hashCode;
  }
}
